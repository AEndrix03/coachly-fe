#!/usr/bin/env python3
"""Genera le icone di lancio Android e iOS da `assets/brand/app_logo.png`.

Il logo del bundle e l'icona di lancio sono lo stesso marchio: questo script
esiste perche' restino lo stesso marchio anche dopo il prossimo ritocco. Si
rilancia quando `app_logo.png` cambia, e non serve nessuna dipendenza nuova in
`pubspec.yaml` (`.claude/rules/development.md`, divieto 16).

    python tool/generate_app_icons.py

Il colore di fondo e' `CoachlyPalette.ink900`, la stessa `surface` del tema:
non e' un colore inventato per l'icona. Se cambia in
`lib/design_system/tokens/coachly_palette.dart`, va cambiato anche qui — lo
script lo verifica e si ferma se i due valori divergono.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
LOGO = ROOT / "assets" / "brand" / "app_logo.png"
PALETTE = ROOT / "lib" / "design_system" / "tokens" / "coachly_palette.dart"

# Token di riferimento per il fondo opaco dell'icona.
BACKGROUND_TOKEN = "ink900"
BACKGROUND = (0x07, 0x10, 0x0F, 0xFF)

# Frazione del lato occupata dal logo.
# Android adaptive: la zona sicura e' 66/108 del canvas, il resto puo' essere
# ritagliato da qualsiasi maschera del launcher.
ADAPTIVE_SAFE_FRACTION = 0.58
# Icone piene (legacy Android, iOS): la maschera e' molto meno aggressiva.
FULL_BLEED_FRACTION = 0.72

ANDROID_RES = ROOT / "android" / "app" / "src" / "main" / "res"
ANDROID_LEGACY = {  # mipmap suffix -> lato in px
    "mdpi": 48,
    "hdpi": 72,
    "xhdpi": 96,
    "xxhdpi": 144,
    "xxxhdpi": 192,
}
# Il canvas adaptive e' 108dp, cioe' 2.25x il lato legacy di ogni densita'.
ANDROID_ADAPTIVE = {suffix: round(size * 108 / 48) for suffix, size in ANDROID_LEGACY.items()}

IOS_APPICON = ROOT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"


def read_background_from_tokens() -> tuple[int, int, int, int]:
    """Rilegge il token di colore dal design system e lo confronta con la costante.

    Serve a impedire la deriva silenziosa fra il tema e l'icona: se il token
    cambia e questo file no, lo script si ferma invece di produrre un'icona con
    un fondo che non esiste piu' da nessuna parte.
    """
    source = PALETTE.read_text(encoding="utf-8")
    match = re.search(rf"{BACKGROUND_TOKEN}\s*=\s*Color\(0x([0-9A-Fa-f]{{8}})\)", source)
    if match is None:
        sys.exit(f"Token '{BACKGROUND_TOKEN}' non trovato in {PALETTE.relative_to(ROOT)}")

    value = int(match.group(1), 16)
    alpha, red, green, blue = (
        (value >> 24) & 0xFF,
        (value >> 16) & 0xFF,
        (value >> 8) & 0xFF,
        value & 0xFF,
    )
    found = (red, green, blue, alpha)
    if found != BACKGROUND:
        sys.exit(
            f"Il token '{BACKGROUND_TOKEN}' vale ora #{value:08X} ma questo script usa "
            f"#{BACKGROUND[3]:02X}{BACKGROUND[0]:02X}{BACKGROUND[1]:02X}{BACKGROUND[2]:02X}. "
            "Allinea BACKGROUND e rilancia."
        )
    return found


def load_trimmed_logo() -> Image.Image:
    """Carica il logo e rimuove il margine trasparente.

    Senza il trim ogni icona eredita il margine del PNG sorgente e il marchio
    risulta piu' piccolo del dovuto dentro la maschera del launcher.
    """
    logo = Image.open(LOGO).convert("RGBA")
    bbox = logo.getbbox()
    return logo.crop(bbox) if bbox else logo


def centered(logo: Image.Image, canvas: int, fraction: float) -> Image.Image:
    """Riquadro trasparente `canvas`x`canvas` con il logo centrato e scalato."""
    target = max(1, round(canvas * fraction))
    scaled = logo.copy()
    scaled.thumbnail((target, target), Image.LANCZOS)

    layer = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    layer.paste(
        scaled,
        ((canvas - scaled.width) // 2, (canvas - scaled.height) // 2),
        scaled,
    )
    return layer


def rounded_square(size: int, radius_fraction: float = 0.22) -> Image.Image:
    """Fondo opaco con angoli arrotondati, per i launcher senza maschera propria."""
    # Disegnato a 4x e ridotto: `rounded_rectangle` non ha antialiasing.
    scale = 4
    mask = Image.new("L", (size * scale, size * scale), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, size * scale - 1, size * scale - 1),
        radius=round(size * scale * radius_fraction),
        fill=255,
    )
    mask = mask.resize((size, size), Image.LANCZOS)

    background = Image.new("RGBA", (size, size), BACKGROUND)
    background.putalpha(mask)
    return background


def write(image: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, "PNG")
    print(f"  {path.relative_to(ROOT).as_posix()}  {image.width}x{image.height}")


def generate_android(logo: Image.Image) -> None:
    print("Android — icone legacy (pre API 26)")
    for suffix, size in ANDROID_LEGACY.items():
        icon = rounded_square(size)
        icon.alpha_composite(centered(logo, size, FULL_BLEED_FRACTION))
        write(icon, ANDROID_RES / f"mipmap-{suffix}" / "ic_launcher.png")

    print("Android — foreground adaptive (API 26+)")
    for suffix, size in ANDROID_ADAPTIVE.items():
        write(
            centered(logo, size, ADAPTIVE_SAFE_FRACTION),
            ANDROID_RES / f"mipmap-{suffix}" / "ic_launcher_foreground.png",
        )

    print("Android — risorse XML")
    red, green, blue, _ = BACKGROUND
    (ANDROID_RES / "values").mkdir(parents=True, exist_ok=True)
    (ANDROID_RES / "values" / "ic_launcher_background.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        "<resources>\n"
        f'    <color name="ic_launcher_background">#{red:02X}{green:02X}{blue:02X}</color>\n'
        "</resources>\n",
        encoding="utf-8",
    )
    print("  android/app/src/main/res/values/ic_launcher_background.xml")

    adaptive = (
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@color/ic_launcher_background" />\n'
        '    <foreground android:drawable="@mipmap/ic_launcher_foreground" />\n'
        '    <monochrome android:drawable="@mipmap/ic_launcher_foreground" />\n'
        "</adaptive-icon>\n"
    )
    for folder in ("mipmap-anydpi-v26",):
        target = ANDROID_RES / folder
        target.mkdir(parents=True, exist_ok=True)
        for name in ("ic_launcher.xml", "ic_launcher_round.xml"):
            (target / name).write_text(adaptive, encoding="utf-8")
            print(f"  android/app/src/main/res/{folder}/{name}")


def generate_ios(logo: Image.Image) -> None:
    """Le icone iOS sono opache: un canale alpha fa rifiutare la build da App Store."""
    print("iOS — AppIcon.appiconset")
    contents = json.loads((IOS_APPICON / "Contents.json").read_text(encoding="utf-8"))

    for entry in contents["images"]:
        filename = entry.get("filename")
        if not filename:
            continue
        size = round(float(entry["size"].split("x")[0]) * float(entry["scale"].rstrip("x")))

        icon = Image.new("RGBA", (size, size), BACKGROUND)
        icon.alpha_composite(centered(logo, size, FULL_BLEED_FRACTION))
        write(icon.convert("RGB"), IOS_APPICON / filename)


def main() -> int:
    if not LOGO.exists():
        sys.exit(f"Logo non trovato: {LOGO.relative_to(ROOT)}")

    read_background_from_tokens()
    logo = load_trimmed_logo()
    print(f"Sorgente: {LOGO.relative_to(ROOT).as_posix()} ({logo.width}x{logo.height} dopo il trim)\n")

    generate_android(logo)
    print()
    generate_ios(logo)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

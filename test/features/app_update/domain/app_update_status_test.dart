import 'package:coachly/features/app_update/domain/app_update_status.dart';
import 'package:coachly/features/app_update/domain/app_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppVersion', () {
    test('ordina per numero, non per stringa', () {
      // Il caso che rompe il confronto lessicografico: "1.10.0" < "1.9.0"
      // come stringhe, ma 1.10.0 e' la versione piu' recente. Sbagliarlo
      // significa bloccare fuori tutti gli utenti al primo minor a due cifre.
      final ten = AppVersion.tryParse('1.10.0')!;
      final nine = AppVersion.tryParse('1.9.0')!;

      expect(ten > nine, isTrue);
      expect('1.10.0'.compareTo('1.9.0') < 0, isTrue);
    });

    test('tollera il suffisso di build e di pre-release', () {
      expect(AppVersion.tryParse('1.2.3+45'), AppVersion.tryParse('1.2.3'));
      expect(AppVersion.tryParse('1.2.3-beta.1'), AppVersion.tryParse('1.2.3'));
    });

    test('completa le parti mancanti con zero', () {
      expect(AppVersion.tryParse('2'), const AppVersion(2, 0, 0));
      expect(AppVersion.tryParse('2.1'), const AppVersion(2, 1, 0));
    });

    test('rifiuta cio che non e una versione', () {
      for (final raw in ['', '  ', 'latest', '1.2.3.4', '1.-2.0', 'v1.2.3']) {
        expect(AppVersion.tryParse(raw), isNull, reason: raw);
      }
    });
  });

  group('AppRequirements.statusFor', () {
    const requirements = AppRequirements(
      minSupportedVersion: '1.4.0',
      recommendedVersion: '1.6.0',
    );

    test('sotto la minima blocca', () {
      expect(
        requirements.statusFor('1.3.9'),
        AppUpdateStatus.updateRequired,
      );
    });

    test('fra minima e consigliata avvisa', () {
      expect(
        requirements.statusFor('1.5.0'),
        AppUpdateStatus.updateRecommended,
      );
    });

    test('esattamente alla minima non blocca', () {
      expect(
        requirements.statusFor('1.4.0'),
        AppUpdateStatus.updateRecommended,
      );
    });

    test('pari o sopra la consigliata non dice nulla', () {
      expect(requirements.statusFor('1.6.0'), AppUpdateStatus.upToDate);
      expect(requirements.statusFor('2.0.0'), AppUpdateStatus.upToDate);
    });

    test('una soglia malformata non blocca mai', () {
      // Un typo in una variabile d'ambiente non deve chiudere gli utenti fuori
      // dai propri dati, che vivono solo sul dispositivo.
      const broken = AppRequirements(
        minSupportedVersion: 'boh',
        recommendedVersion: '',
      );
      expect(broken.statusFor('1.0.0'), AppUpdateStatus.upToDate);
    });

    test('una versione installata illeggibile non blocca mai', () {
      expect(requirements.statusFor('sconosciuta'), AppUpdateStatus.upToDate);
    });
  });
}

import 'package:flutter/material.dart';

abstract final class CoachlyAthleteTheme {
  static const background = Color(0xFF07100F);
  static const surface = Color(0xFF0D1717);
  static const surfaceElevated = Color(0xFF12201F);
  static const primary = Color(0xFF20D3B0);
  static const textPrimary = Color(0xFFF2F7F6);
  static const textSecondary = Color(0xFF96A7A4);
  static const danger = Color(0xFFFF6B6B);
  static const border = Color(0x17FFFFFF);

  static const pagePadding = EdgeInsets.symmetric(horizontal: 20);
  static const sectionGap = 28.0;
  static const cardRadius = 18.0;

  static const expandDuration = Duration(milliseconds: 200);
  static const pageDuration = Duration(milliseconds: 280);
  static const standardCurve = Curves.easeOutCubic;
}

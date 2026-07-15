import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static const fontFamily = 'Manrope';

  static TextTheme textTheme(Color textColor) {
    return TextTheme(
      headlineMedium: TextStyle(
        color: textColor,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.08,
      ),
      headlineSmall: TextStyle(
        color: textColor,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.12,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 1.18,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      bodyLarge: TextStyle(color: textColor, fontSize: 16, height: 1.35),
      bodyMedium: TextStyle(color: textColor, fontSize: 14, height: 1.35),
      bodySmall: TextStyle(color: textColor, fontSize: 12, height: 1.35),
      labelLarge: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      labelMedium: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
    ).apply(fontFamily: fontFamily);
  }
}

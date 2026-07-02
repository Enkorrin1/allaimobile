import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme textTheme(Color textColor) {
    return TextTheme(
      headlineMedium: TextStyle(
        color: textColor,
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(color: textColor, fontSize: 16, height: 1.35),
      bodyMedium: TextStyle(color: textColor, fontSize: 14, height: 1.35),
      labelLarge: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF312783);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color redColor = Color(0xFFFF0000);
  static const Color borderColor = Color(0xFFC6C6C6);
  static const Color textColor = Color(0xFF545454);
  static const Color mainTextColor = Color(0xFF20292F);
  static const Color drawerColor = Color(0xFFC6C6C6);
  static const Color drawerHeaderColor = Color(0xFF314450);
  static const Color primaryPurple = Color(0xFFF6F7FA);
}

MaterialColor getPrimaryMaterialColor(Color color) {
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

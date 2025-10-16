import 'package:flutter/material.dart';

class CNavigationbarTheme {
  CNavigationbarTheme._();

  static NavigationBarThemeData lightNavbarTheme = const NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 247, 251, 255),
    surfaceTintColor: Color.fromARGB(255, 19, 38, 48),
    indicatorColor: Color.fromARGB(255, 116, 192, 254),
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 19, 38, 48),
      ),
    ),
    elevation: 2,
  );

  static NavigationBarThemeData darkNavbarTheme = const NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 247, 251, 255),
    surfaceTintColor: Color.fromARGB(255, 19, 38, 48),
    indicatorColor: Color.fromARGB(255, 116, 192, 254),
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 19, 38, 48),
      ),
    ),
    elevation: 2,
  );
}

import 'package:flutter/material.dart';

class ThemeChange {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.amber,
      onPrimary: Colors.amberAccent,
      secondary: Colors.black54,
      onSecondary: Colors.amber.shade100,
      error: Colors.amberAccent.shade100,
      onError: Colors.red,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black,
      onPrimary: Colors.amberAccent,
      secondary: Colors.black54,
      onSecondary: Colors.amber.shade100,
      error: Colors.amberAccent.shade100,
      onError: Colors.red,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );
}

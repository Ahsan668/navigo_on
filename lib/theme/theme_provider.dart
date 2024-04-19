import'package:flutter/material.dart';

class Theme{
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black12,
    colorScheme: ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(),
  );

}
import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      scrolledUnderElevation: 0,
    ),
    iconTheme: IconThemeData(color: ColorConstants.secondaryColor),
  );
}

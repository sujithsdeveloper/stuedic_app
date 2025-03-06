import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';

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
    dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        textStyle: TextStyle(
            color: ColorConstants.secondaryColor, fontFamily: 'latoRegular')),
    textSelectionTheme: TextSelectionThemeData(
        selectionColor: ColorConstants.primaryColor2.withOpacity(0.7),
        cursorColor: ColorConstants.secondaryColor,
        selectionHandleColor: ColorConstants.secondaryColor),
  );
}

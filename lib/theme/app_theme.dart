import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: ColorConstants.secondaryColor,
        unselectedItemColor: Colors.grey),
    textTheme: lightTextTheme(),
    
    iconTheme: IconThemeData(color: ColorConstants.secondaryColor),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConstants.secondaryColor,
        textStyle: TextStyle(
          fontFamily: 'latoRegular',
        ),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        textStyle: TextStyle(
            color: ColorConstants.secondaryColor, fontFamily: 'latoRegular')),
    textSelectionTheme: TextSelectionThemeData(
        selectionColor: ColorConstants.primaryColor2.withOpacity(0.7),
        cursorColor: ColorConstants.secondaryColor,
        selectionHandleColor: ColorConstants.secondaryColor),
  );


  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ColorConstants.darkColor,
    primaryColor: ColorConstants.darkColor,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.darkColor,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: TextStyle(
          fontFamily: 'latoRegular',
        ),
      ),
    ),
    textTheme: darkTextTheme(),
    iconTheme: IconThemeData(color: ColorConstants.darkColor2),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.darkSecondaryColor,
        selectedItemColor: ColorConstants.darkColor2,
        unselectedItemColor: Colors.grey),
    dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        textStyle: TextStyle(color: Colors.white, fontFamily: 'latoRegular')),
    textSelectionTheme: TextSelectionThemeData(
        selectionColor: ColorConstants.primaryColor2.withOpacity(0.7),
        cursorColor: Colors.white,
        selectionHandleColor: ColorConstants.secondaryColor),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.white,
    ),
  );


  static TextTheme darkTextTheme() {
    return TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'Calistoga',
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'latoRegular',
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontFamily: 'latoRegular',
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'latoRegular',
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'latoRegular',
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontFamily: 'latoRegular',
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'latoRegular',
    ),
    labelMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'latoRegular',
    ),
    labelSmall: TextStyle(
      color: Colors.white,
      fontFamily: 'latoRegular',
    ),
  );
  }

    static TextTheme lightTextTheme() {
    return TextTheme(
    bodyLarge: TextStyle(
      color: ColorConstants.secondaryColor,
      fontFamily: 'latoRegular',
    ),
    bodyMedium: TextStyle(
      color: ColorConstants.secondaryColor,
      fontFamily: 'latoRegular',
    ),
    bodySmall: TextStyle(
      color: ColorConstants.secondaryColor,
      fontFamily: 'latoRegular',
    ),
    titleLarge: TextStyle(
      color: ColorConstants.secondaryColor,
      fontFamily: 'latoRegular',
    ),
    titleMedium: TextStyle(
      color: ColorConstants.secondaryColor,
      fontFamily: 'latoRegular',
    ),
    titleSmall: TextStyle(
      color: ColorConstants.secondaryColor,
      fontFamily: 'latoRegular',
    ),
    labelLarge: TextStyle(
      color: ColorConstants.secondaryColor,
      fontFamily: 'latoRegular',
    ),
    labelMedium: TextStyle(
      color: ColorConstants.secondaryColor,
      fontFamily: 'latoRegular',
    ),
    labelSmall: TextStyle(
      color: ColorConstants.secondaryColor,
      fontFamily: 'latoRegular',
    ),
  );
  }
}

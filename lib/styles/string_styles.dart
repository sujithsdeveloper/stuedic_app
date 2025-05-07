import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class StringStyle {
  static TextStyle appBarText(
      {double size = 18, required BuildContext context}) {
    bool isDarktheme = AppUtils.isDarkTheme(context);
    return TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDarktheme ? Colors.white : ColorConstants.secondaryColor,
        fontFamily: 'Calistoga');
  }

  static TextStyle smallText({bool isBold = false,Color?color}) => TextStyle(
      fontSize: 12,
      fontWeight: isBold ? FontWeight.w700 : null,
      color: color,
      fontFamily: 'latoRegular');

  static TextStyle normalText({double size = 16, bool isBold = false,Color?color}) =>
      TextStyle(
color: color,
          fontFamily: 'latoRegular',
          fontSize: size,
          fontWeight: isBold ? FontWeight.bold : null);

  static TextStyle normalTextBold(
          {double? size, Color? color, bool isCallistga = false}) =>
      TextStyle(
          fontFamily: isCallistga ? 'Calistoga' : 'latoRegular',
          color: color,
          fontSize: size == null ? null : size,
          fontWeight: FontWeight.bold);

  static TextStyle topHeading({double size = 45}) {
    return TextStyle(fontSize: size, fontWeight: FontWeight.bold);
  }

  static TextStyle greyText({double size = 10, bool isBold = false}) {
    return TextStyle(
        fontWeight: isBold ? FontWeight.bold : null,
        color: Colors.grey,
        fontFamily: 'latoRegular',
        fontSize: size);
  }
}

import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class StringStyle {
  static TextStyle appBarText({double size = 18}) => TextStyle(
      color: ColorConstants.secondaryColor,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: 'Calistoga');

  static TextStyle smallText({bool isBold = false}) => TextStyle(
      color: ColorConstants.secondaryColor,
      fontSize: 12,
      fontWeight: isBold ? FontWeight.w700 : null,
      fontFamily: 'latoRegular');

  static TextStyle normalText(
          {Color color = ColorConstants.secondaryColor,
          double size = 16,
          bool isBold = false}) =>
      TextStyle(
          fontFamily: 'latoRegular',
          color: color,
          fontSize: size,
          fontWeight: isBold ? FontWeight.bold : null);

  static TextStyle normalTextBold({
    double? size,
    Color color = ColorConstants.secondaryColor,
  }) =>
      TextStyle(
          color: color,
          fontFamily: 'latoRegular',
          fontSize: size == null ? null : size,
          fontWeight: FontWeight.bold);

  static TextStyle topHeading({double size = 45}) {
    return TextStyle(
        fontSize: size,
        fontFamily: 'lato',
        color: ColorConstants.secondaryColor,
        fontWeight: FontWeight.bold);
  }

  static TextStyle greyText({double size = 10, bool isBold = false}) {
    return TextStyle(
        fontWeight: isBold ? FontWeight.bold : null,
        color: Colors.grey,
        fontFamily: 'latoRegular',
        fontSize: size);
  }
}

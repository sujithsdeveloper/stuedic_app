import 'package:flutter/material.dart';

class ColorConstants {
  static const Color primaryColor = Color(0xFFF5FF25);
  static const Color primaryColor2 = Color(0xffCAF945);
  static const Color secondaryColor = Color(0xFF1F2232);
  static const Color greyColor = Color(0xFFF6F8F9);
  static const Gradient primaryGradientHorizontal =
      LinearGradient(colors: [Color(0xFFF5FF25), Color(0xFFCAF945)]);
  static const Gradient primaryGradientVertical = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF5FF25), Color(0xFFCAF945)]);
}

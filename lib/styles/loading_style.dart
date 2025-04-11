import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';

Widget loadingIndicator({Color? color}) {
  return Center(
    child: Lottie.asset(height: 90, LottieAnimations.loading),
  );
}

import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class GradientCircleAvathar extends StatelessWidget {
  const GradientCircleAvathar({
    super.key,
    this.radius = 60,
    this.child,
    this.onTap,
  });
  final double radius;
  final Widget? child;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ColorConstants.primaryGradientHorizontal),
          child: Center(child: child)),
    );
  }
}

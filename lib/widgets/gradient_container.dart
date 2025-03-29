import 'package:flutter/cupertino.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer(
      {super.key,
      required this.height,
      required this.width,
      this.verticalGradient = false, this.decoration, this.child});
  final double height;
  final double width;
  final bool verticalGradient;
  final BoxDecoration? decoration;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: child,
      decoration:decoration==null? BoxDecoration(
          gradient: verticalGradient
              ? ColorConstants.primaryGradientVertical
              : ColorConstants.primaryGradientHorizontal) :decoration
    );
  }
}

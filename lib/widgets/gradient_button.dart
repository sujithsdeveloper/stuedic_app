import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';


class GradientButton extends StatelessWidget {
  const GradientButton(
      {super.key,
      this.height = 56,
      this.width = 327,
      required this.label,
      this.onTap,
      this.isColored = false});
  final double height;
  final double width;
  final String label;
  final bool isColored;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: prowatch.isButtonColored ? null : Color(0xffE7ECF0),
          gradient: prowatch.isButtonColored || isColored
              ? ColorConstants.primaryGradientHorizontal
              : null,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, fontFamily: 'lato'),
          ),
        ),
      ),
    );
  }
}

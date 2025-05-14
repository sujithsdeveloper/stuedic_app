import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class GradientButton extends StatelessWidget {
  const GradientButton(
      {super.key,
      this.height = 56,
      this.width = 327,
      required this.label,
      this.onTap,
      this.isColored = false,
      this.outline = false});
  final double height;
  final double width;
  final String label;
  final bool isColored;
  final bool outline;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();
    bool isDarkTheme = AppUtils.isDarkTheme(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: outline ? Border.all() : null,
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
                fontWeight: FontWeight.w700,
                fontSize: 14,
                fontFamily: 'lato',
                color:
                    isDarkTheme ? Colors.white : ColorConstants.secondaryColor),
          ),
        ),
      ),
    );
  }
}

class CustomOutLinedButton extends StatelessWidget {
  const CustomOutLinedButton({super.key, required this.label, this.onTap});
  final String label;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class StuedicPointContainer extends StatelessWidget {
  const StuedicPointContainer({
    super.key,
    required this.point,
  });
  final String point;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
          color: ColorConstants.greyColor,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 3,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                fit: BoxFit.cover,
                height: 22,
                width: 22,
                ImageConstants.points),
            Text(point, style: StringStyle.normalTextBold())
          ],
        ),
      ),
    );
  }
}

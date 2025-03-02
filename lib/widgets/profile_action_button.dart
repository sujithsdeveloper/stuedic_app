
import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class ProfileActionButton extends StatelessWidget {
  const ProfileActionButton({
    super.key, this.onTap, required this.iconData,
  });
final Function()? onTap;
final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 23.5,
        backgroundColor: ColorConstants.greyColor,
        child: Icon(
          iconData,
          color: ColorConstants.secondaryColor,
        ),
      ),
    );
  }
}

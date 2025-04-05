
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';


Widget buildToggleButton(String text, bool isEmail,BuildContext context) {
    final prowatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();
    return Expanded(
      child: GestureDetector(
        onTap: () {
          proRead.toggleEmailPhoneNumber(isEmail);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 48,
          curve: Easing.legacy,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: prowatch.isEmailSelected == isEmail
                ? ColorConstants.secondaryColor
                : Color(0xffF6F8F9),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: prowatch.isEmailSelected == isEmail
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
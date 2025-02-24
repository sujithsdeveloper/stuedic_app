  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/controller/API_controller.dart/auth_controller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

Future<dynamic> logoutDialog(BuildContext context, AuthController proReadAuth) {
    return showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text("You're leaving"),
            content: Text(
              "Are you sure to want logout?",
              style: TextStyle(color: ColorConstants.secondaryColor),
            ),
            actions: [
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                  )),
              CupertinoDialogAction(
                  onPressed: () {
                    proReadAuth.logoutUser(context: context);
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
        );
  }
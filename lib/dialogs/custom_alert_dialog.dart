import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> customDialog(BuildContext context,
    {required String title,
    required String subtitle,
    bool Function()? onPop,
    required List<CupertinoDialogAction> actions}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          if (onPop != null) {
            onPop();
          }
          return true;
        },
        child: CupertinoAlertDialog(
            title: Text(title), content: Text(subtitle), actions: actions),
      );
    },
  );
}

  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

Future<dynamic> unFollowUserDialog({required BuildContext context, required int index,required Function() OnUnfollow}) {
    return showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Do you want unfollow user?"),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: ColorConstants.secondaryColor),
            ),
          ),
          CupertinoDialogAction(
            onPressed: OnUnfollow,
            child: Text('Unfollow',
                style: TextStyle(color: ColorConstants.secondaryColor)),
          ),
        ],
      ),
    );
  }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/view/screens/chat/call_page.dart';

Future<dynamic> callAlertDialog(
    {required BuildContext context,
    required String userId,
    required String callID,
    required String userName,
    bool isVoice = false}) {
  return showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(isVoice ? 'Start voice call' : 'Start Video Call'),
        content: Text(isVoice
            ? 'Do you want to start a Voice call with ${userName}?'
            : 'Do you want to start a video call with ${userName}?'),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: Text('Start Call'),
            onPressed: () {
              AppRoutes.push(
                  context,
                  CallPage(
                    callID: callID,
                    isvoice: isVoice,
                    userId: userId,
                    username: userName,
                  ));
            },
          ),
        ],
      );
    },
  );
}

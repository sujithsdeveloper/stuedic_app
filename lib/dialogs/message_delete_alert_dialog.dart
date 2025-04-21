import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> messageDeleteAlertDialog({
  required BuildContext context,
  required Function() onDelete,
}) {
  return showDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text("Delete Messages"), 
      content: Text("Are you sure you want to delete the selected message(s)? This action cannot be undone."),
      actions: [
        CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
            )),
        CupertinoDialogAction(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ))
      ],
    ),
  );
}

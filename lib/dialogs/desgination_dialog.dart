  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> DesiginationDialog(BuildContext context) {
    return showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: Text(
                          'University/ School Registrations are requested to be done through Desktop page of the application.',
                          softWrap: true,
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(
                              'Dissmiss',
                            ),
                            textStyle: TextStyle(color: Color(0xff007AFF)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
  }

  import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';

Future<dynamic> themeSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<ThemeMode>(
          future: AppUtils.getCurrentTheme(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            ThemeMode? themeMode = snapshot.data;

            return Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      if (themeMode == ThemeMode.light) {
                        Navigator.pop(context);
                      } else {
                        await AppUtils.saveTheme(
                            context: context, theme: StringConstants.light);
                        Restart.restartApp(
                          notificationBody: 'Please wait app is restarting',
                          notificationTitle: 'Restarting',
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Light',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeMode == ThemeMode.light
                                ? Colors.blue
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      if (themeMode == ThemeMode.dark) {
                        Navigator.pop(context);
                      } else {
                        await AppUtils.saveTheme(
                            context: context, theme: StringConstants.dark);
                        Restart.restartApp(
                          notificationBody: 'Please wait app is restarting',
                          notificationTitle: 'Restarting',
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dark',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeMode == ThemeMode.dark
                                ? Colors.blue
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
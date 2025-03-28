import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:stuedic_app/controller/API_controller.dart/auth_controller.dart';
import 'package:stuedic_app/dialogs/logout_dialog.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/settings/language_screen.dart';
import 'package:stuedic_app/view/screens/settings/terms_conditions.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proReadAuth = context.read<AuthController>();
    final proWatchAuth = context.watch<AuthController>();
    List<Map> settingData = [
      {
        'label': 'Account',
        'icon': CupertinoIcons.person_circle,
        'onTap': () {},
      },
      {
        'label': 'Theme',
        'icon': CupertinoIcons.color_filter,
        'onTap': () {
          themeSheet(context);
        },
      },
      {
        'label': 'Notifications',
        'icon': CupertinoIcons.bell,
        'onTap': () {},
      },
      {
        'label': 'Language',
        'icon': CupertinoIcons.globe,
        'onTap': () {
          AppRoutes.push(context, LanguageScreen());
        },
      },
      {
        'label': 'Report a problem',
        'icon': HugeIcons.strokeRoundedFlag01,
        'onTap': () {},
      },
      {
        'label': 'About Studeic',
        'icon': CupertinoIcons.info_circle,
        'onTap': () {},
      },
      {
        'label': 'Contact us',
        'icon': HugeIcons.strokeRoundedMail01,
        'onTap': () {},
      },
      {
        'label': 'Terms and conditions',
        'icon': CupertinoIcons.info,
        'onTap': () {
          AppRoutes.push(context, TermsAndConditions());
        },
      },
      {
        'label': 'Logout',
        'icon': HugeIcons.strokeRoundedLogout03,
        'onTap': () {
          logoutDialog(context, proReadAuth);
        },
      },
    ];
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Stuedic",
            style: StringStyle.topHeading(size: 25),
          ),
          Text("Version 1.0.0"),
          SizedBox(
            height: 25,
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          "Settings",
          style: StringStyle.appBarText(context: context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: List.generate(
                settingData.length,
                (index) => SettingItem(
                  label: settingData[index]['label'],
                  iconData: settingData[index]['icon'],
                  onTap: settingData[index]['onTap'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}

class SettingItem extends StatelessWidget {
  const SettingItem(
      {super.key, required this.label, required this.iconData, this.onTap});
  final String label;
  final IconData iconData;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        color: ColorConstants.secondaryColor,
        size: 24,
      ),
      title: Text(
        label,
        style: StringStyle.normalTextBold(size: 16),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: ColorConstants.secondaryColor,
      ),
    );
  }
}

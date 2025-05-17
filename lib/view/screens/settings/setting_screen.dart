import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/auth_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/dialogs/custom_alert_dialog.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/theme_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/app_info.dart';
import 'package:stuedic_app/view/screens/settings/about_page.dart';

import 'package:stuedic_app/view/screens/settings/account/account_settings.dart';
import 'package:stuedic_app/view/screens/settings/contact_us.dart';
import 'package:stuedic_app/view/screens/settings/language_screen.dart';
import 'package:stuedic_app/view/screens/settings/notification_settings.dart';
import 'package:stuedic_app/view/screens/settings/report_problem.dart';
import 'package:stuedic_app/view/screens/settings/terms_conditions.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proReadAuth = context.read<AuthController>();
    // final proWatchAuth = context.watch<AuthController>();
    List<Map> settingData = [
      {
        'label': 'Account',
        'icon': CupertinoIcons.person_circle,
        'onTap': () {
          AppRoutes.push(context, AccountSettings());
        },
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
        'onTap': () async {
          bool isNotificationEnabled =
              await AppUtils.getNotificationConfigure();
          AppRoutes.push(
              context,
              NotificationSettings(
                  isNotificationEnabled: isNotificationEnabled));
        },
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
        'onTap': () {
          AppRoutes.push(context, ReportProblemScreen());
        },
      },
      {
        'label': 'About Studeic',
        'icon': CupertinoIcons.info_circle,
        'onTap': () {
          AppRoutes.push(context, AboutPage());
        },
      },
      {
        'label': 'Contact us',
        'icon': HugeIcons.strokeRoundedMail01,
        'onTap': () {
          AppRoutes.push(context, ContactUs());
        },
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
          customDialog(
            context,
            title: "You're leaving",
            subtitle: "Are you sure to want logout?",
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
                    Provider.of<AppContoller>(context, listen: false)
                        .clearState();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        },
      },
    ];
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppInfo.appName,
            style: StringStyle.topHeading(size: 25),
          ),
          Text("Version ${AppInfo.appVersion}"),
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
        size: 24,
      ),
      title: Text(
        label,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
    );
  }
}

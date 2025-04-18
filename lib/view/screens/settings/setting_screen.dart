import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:stuedic_app/controller/API_controller.dart/auth_controller.dart';
import 'package:stuedic_app/dialogs/logout_dialog.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/theme_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/settings/account/account_settings.dart';
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

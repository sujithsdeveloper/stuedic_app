import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/notification_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  late bool isNotificationEnabled;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        isNotificationEnabled = await AppUtils.getNotificationConfigure();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<NotificationController>();
    final proRead = context.read<NotificationController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings',
            style: StringStyle.appBarText(context: context)),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Enable Notifications',
              style: StringStyle.normalTextBold(size: 18),
            ),
            trailing: Switch(
              value: isNotificationEnabled,
              onChanged: (value) {
                proRead.toggleNotification(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
                'If this is disabled, you will not receive any notifications including local notifications, Chat Messages etc',
                style: StringStyle.normalText()),
          ),
        ],
      ),
    );
  }
}

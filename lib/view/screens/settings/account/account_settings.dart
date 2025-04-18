import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map> accountDatas = [
      {
        'label': 'Change Password',
        'icon': Icons.lock,
        'onTap': () {
          AppRoutes.push(context, ChangePasswrordScreen());
        }
      },
      {
        'label': 'Delete Account',
        'icon': Icons.delete,
        'onTap': () {
          // Show delete account confirmation dialog
        }
      },
      {
        'label': 'Privacy Settings',
        'icon': Icons.privacy_tip,
        'onTap': () {
          // Navigate to privacy settings screen
        }
      },
      {
        'label': 'Notification Settings',
        'icon': Icons.notifications,
        'onTap': () {
          // Navigate to notification settings screen
        }
      }
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Settings',
          style: StringStyle.normalTextBold(size: 20),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: accountDatas.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(accountDatas[index]['icon']),
              title: Text(accountDatas[index]['label']),
              onTap: accountDatas[index]['onTap'],
            ),
          )),
    );
  }
}

class ChangePasswrordScreen extends StatefulWidget {
  const ChangePasswrordScreen({super.key});

  @override
  State<ChangePasswrordScreen> createState() => _ChangePasswrordScreenState();
}

class _ChangePasswrordScreenState extends State<ChangePasswrordScreen> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProfileController>();
    final providerWatch = context.watch<ProfileController>();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: StringStyle.normalTextBold(size: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 20,
            children: [
              TextfieldWidget(
                  hint: 'Current Password',
                  controller: currentPasswordController),
              TextfieldWidget(
                  validator: (p0) => passwordValidator(p0),
                  hint: 'New Password',
                  controller: newPasswordController),
              TextfieldWidget(
                  validator: (p0) =>
                      confirmPasswordValidator(p0, newPasswordController.text),
                  hint: 'Confirm Password',
                  controller: confirmPasswordController),
              providerWatch.isPasswordLoading
                  ? loadingIndicator()
                  : GradientButton(
                      isColored: true,
                      label: 'Change Password',
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          provider.changePassword(
                              oldPassword: currentPasswordController.text,
                              newPassword: confirmPasswordController.text,
                              context: context);
                        }
                      }),
            ],
          ),
        ),
      ),
    );
  }
}

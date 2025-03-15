import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/auth_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_nav_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';

class FinishSetup extends StatefulWidget {
  const FinishSetup(
      {super.key, this.collegeName, this.deptName, this.userName});
  final String? collegeName;
  final String? deptName;
  final String? userName;
  @override
  State<FinishSetup> createState() => _FinishSetupState();
}

class _FinishSetupState extends State<FinishSetup> {
  late String email;
  late String password;
  late String role;
  late String userName;
  late String collegeName;
  late String deptName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        email = (await AppUtils.getCredentials(getMail: true))!;
        password = (await AppUtils.getCredentials(getMail: false))!;
        role = (await AppUtils.getRole())!;
        userName = (await AppUtils.getForm())!;
        collegeName = (await AppUtils.getForm(isCollegeName: true))!;
        deptName = (await AppUtils.getForm(isDeptName: true))!;
        log('email $email');
        log('password $password');
        log('role $role');
        log('college  $collegeName');
        log('Dept name $deptName');
        log('username $userName');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'All Done',
            style: StringStyle.topHeading(size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Review your details before proceeding.',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          GradientButton(
            isColored: true,
            label: 'Finish Setup',
            onTap: () {
              context.read<AuthController>().createAccount(
                  context: context,
                  email: email,
                  userName: userName,
                  collegeName: collegeName,
                  phoneNumber: '',
                  collegeIDUrl: '',
                  password: password,
                  role: role);
            },
          ),
        ],
      ),
    );
  }
}

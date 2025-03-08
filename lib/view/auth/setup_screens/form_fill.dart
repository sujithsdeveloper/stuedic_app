import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/view/auth/setup_screens/college_registration.dart';
import 'package:stuedic_app/widgets/dropdown_widget.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class FormFill extends StatefulWidget {
  const FormFill({
    super.key,
    required this.prowatch,
    required this.proRead,
    required this.nextPage,
  });

  final AppContoller prowatch;
  final AppContoller proRead;
  final Function() nextPage;

  @override
  State<FormFill> createState() => _FormFillState();
}

class _FormFillState extends State<FormFill> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ConfirmpasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    log(widget.prowatch.publicUser.toString());
  }

  @override
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();

    return Builder(
      builder: (context) {
        if (widget.prowatch.collegeStaff || widget.prowatch.student) {
          return CollegeRegistration(
            emailController: emailController,
            nameController: nameController,
            nextPage: widget.nextPage,
          );
        }

        if (widget.prowatch.publicUser) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 9,
                  children: [
                    const SizedBox(height: 20),

                    /// Full Name
                    FormItem(
                      child: TextfieldWidget(
                        borderColor: ColorConstants.greyColor,
                        hint: 'Name',
                        validator: (p0) => nameValidator(p0, 'Name'),
                        controller: nameController,
                      ),
                      title: 'Full Name',
                    ),

                    /// Email
                    FormItem(
                      title: "Email",
                      child: TextfieldWidget(
                        borderColor: ColorConstants.greyColor,
                        controller: emailController,
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (p0) => emailValidator(p0),
                      ),
                    ),
                    FormItem(
                      title: "Password",
                      child: TextfieldWidget(
                        dismissKeyboardOnTapOutside: false,
                        borderColor: ColorConstants.greyColor,
                        controller: passwordController,
                        isPassword: true,
                        hint: 'Password',
                        validator: (p0) => passwordValidator(p0),
                      ),
                    ),
                    FormItem(
                      title: "Confirm Password",
                      child: TextfieldWidget(
                        dismissKeyboardOnTapOutside: false,
                        borderColor: ColorConstants.greyColor,
                        controller: ConfirmpasswordController,
                        isPassword: true,
                        hint: 'Confirm Password',
                        validator: (p0) => confirmPasswordValidator(
                            p0, passwordController.text),
                      ),
                    ),

                    SizedBox(
                      height: 24,
                    ),

                    /// Continue Button
                    GradientButton(
                      width: double.infinity,
                      label: 'Continue',
                      onTap: () async {
                        // if (key.currentState!.validate()) {
                        //   nextPage();
                        // }
                    AppUtils.saveToken(accessToken: '');
                        widget.nextPage();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}

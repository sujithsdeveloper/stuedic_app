import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/college_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/view/auth/setup_screens/college_registration.dart';
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
  final ageController = TextEditingController();
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
                      title: "Age",
                      child: TextfieldWidget(
                          borderColor: ColorConstants.greyColor,
                          controller: ageController,
                          hint: 'Age',
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          validator: (p0) => ageValidator(p0)),
                    ),

                    SizedBox(
                      height: 24,
                    ),

                    /// Continue Button
                    GradientButton(
                      width: double.infinity,
                      label: 'Continue',
                      onTap: () async {
                        if (key.currentState!.validate()) {
                          await AppUtils.saveForm(
                              userName: nameController.text,
                              collegeName: 'Providence college of engineering',
                              deptName: 'Department of computer science');

                          widget.nextPage();
                        }
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

import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/widgets/dropdown_widget.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class CollegeRegistration extends StatelessWidget {
  const CollegeRegistration(
      {super.key,
      required this.nameController,
      required this.nextPage,
      required this.emailController});
  final TextEditingController nameController;
  final TextEditingController emailController;
  final Function() nextPage;
  @override
  Widget build(BuildContext context) {
      final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              const SizedBox(height: 30),

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

              FormItem(
                  title: 'Institution Name',
                  child: DropdownWidget(
                      hint: 'Institution Name',
                      onChanged: (value) {},
                      items: [])),
              FormItem(
                  title: 'Department Name',
                  child: DropdownWidget(
                      hint: 'Dept Name', onChanged: (value) {}, items: [])),

              /// Email
              FormItem(
                title: "Email",
                child: TextfieldWidget(
                  borderColor: ColorConstants.greyColor,
                  controller: emailController,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator, // Fixed: Added email validation
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
                        controller: confirmPasswordController,
                        isPassword: true,
                        hint: 'Confirm Password',
                        validator: (p0) => confirmPasswordValidator(
                            p0, passwordController.text),
                      ),
                    ),

              /// Continue Button
              GradientButton(
                width: double.infinity,
                label: 'Continue',
                onTap: () {
                  // if (key.currentState!.validate()) {
                  //   nextPage();
                  // }
                  nextPage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormItem extends StatelessWidget {
  const FormItem({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StringStyle.normalTextBold(size: 16),
        ),
        const SizedBox(height: 5), // Added spacing
        child,
      ],
    );
  }
}

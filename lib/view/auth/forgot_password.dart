import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/auth_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: StringStyle.appBarText(context: context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 20,
            children: [
              TextfieldWidget(
                controller: controller,
                hint: 'Email',
                validator: (p0) => emailValidator(p0),
              ),
              GradientButton(
                isColored: true,
                label: 'Sent mail',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthController>().forgotPassword(
                        email: controller.text, context: context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

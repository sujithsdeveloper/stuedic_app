import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/view/screens/settings/terms_conditions.dart';

class AgreementText extends StatelessWidget {
  const AgreementText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By continuing, you agree to Stuedic\'s ',
        style: StringStyle.normalText(color: Colors.black),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: StringStyle.normalTextBold(color: Colors.black),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppRoutes.push(context, TermsAndConditions());
              },
          ),
          TextSpan(
            text: ' and ',
            style: StringStyle.normalText(color: Colors.black),
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: StringStyle.normalTextBold(color: Colors.black),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppRoutes.push(context, TermsAndConditions());
              },
          ),
          const TextSpan(
            text: '.',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

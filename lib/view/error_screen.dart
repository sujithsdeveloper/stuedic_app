import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(SVGConstants.error),
            const SizedBox(height: 16),
            Text(
              'An error occurred.',
              style: StringStyle.normalTextBold(size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later.',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_nav_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';

class FinishSetup extends StatelessWidget {
  const FinishSetup({
    super.key,
  });

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
              AppRoutes.pushAndRemoveUntil(context, BottomNavScreen());
            },
          ),
        ],
      ),
    );
  }
}

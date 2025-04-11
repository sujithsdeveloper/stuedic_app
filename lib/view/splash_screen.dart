import 'package:flutter/material.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/auth/login_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_nav_screen.dart';
import 'package:stuedic_app/widgets/gradient_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.token});
  final String token;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then(
      (value) {
        if (widget.token == null || widget.token.isEmpty) {
          AppRoutes.pushAndRemoveUntil(context, LoginScreen());
        } else {
          AppRoutes.pushAndRemoveUntil(context, BottomNavScreen(isfirstTime: true,));
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientContainer(
              height: 82,
              width: 221,
              child: Center(
                child: Text(
                  StringConstants.appName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Calistoga',
                      fontSize: 26),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: ColorConstants.primaryGradientHorizontal),
            ),
            CustomCircularProgressIndicator(color: ColorConstants.primaryColor2)
          ],
        ),
      ),
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color color;

  const CustomCircularProgressIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return CircularProgressIndicator(
          value: value,
          strokeWidth: 6,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: color.withOpacity(0.2),
        );
      },
    );
  }
}

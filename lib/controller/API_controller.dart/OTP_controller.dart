import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/view/auth/setup_screen.dart';

class OtpController extends ChangeNotifier {
  Future<void> getOTP(
      {required String email, required BuildContext context}) async {
    Map<String, dynamic> data = {"userIdentifier": email};
    await ApiCall.post(
      body: data,
      url: APIs.getOtp,
      onSucces: (p0) {
        log(p0.body);
      },
      
      onTokenExpired: () {
        getOTP(email: email, context: context);
      },
      context: context,
    );
  }

  Future<void> checkOtp(
      {required BuildContext context,
      required String email,
      required String otp}) async {
    final data = {"userIdentifier": email, "otp": otp};
    await ApiCall.post(
      body: data,
      snackbarText: 'Invalid OTP',
      url: APIs.checkOtp,
      onSucces: (p0) {
        log(p0.body);
        AppRoutes.push(context, const SetupScreen());
      },
      onTokenExpired: () {
        checkOtp(context: context, email: email, otp: otp);
      },
      context: context,
    );
  }
}

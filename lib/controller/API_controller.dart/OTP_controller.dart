import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/auth/setup_screen.dart';

class OtpController extends ChangeNotifier {
  bool isLoading = false; // Add loading state

  Future<void> getOTP(
      {required String email, required BuildContext context}) async {
    Map<String, dynamic> data = {"userIdentifier": email};
    await ApiMethods.post(
      body: data,
      url: ApiUrls.getOtp,
      onSucces: (p0) {
        log(p0.body);
        customSnackbar(label: 'OTP Sent Succesfully', context: context);
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
    await ApiMethods.post(
      body: data,
      snackbarText: 'Invalid OTP',
      url: ApiUrls.checkOtp,
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

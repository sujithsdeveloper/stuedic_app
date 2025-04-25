import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/auth/setup_screen.dart';

class OtpController extends ChangeNotifier {
  bool isLoading = false; // Add loading state

  Future<void> getOTP(
      {required String email, required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> data = {"UserIdentifier": email};
    try {
      await ApiMethods.post(
        body: data,
        url: ApiUrls.getOtp,
        onSucces: (p0) {
          log(p0.body);
          isLoading = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP Sent Successfully')),
          );
        },
        onTokenExpired: () {
          getOTP(email: email, context: context);
        },
        context: context,
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP')),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> checkOtp(
      {required BuildContext context,
      required String email,
      required TextEditingController otpController}) async {
    log('email: $email');
    log('otp: ${otpController.text}');
    final data = {"UserIdentifier": email, "Otp": otpController.text};
    try {
      var response = await post(
        Uri.parse('${ApiUrls.checkOtp}'),
        body: json.encode(data), 
        headers: {'Content-Type': 'application/json'}, 
      );
      if (response.statusCode == 200) {
        AppRoutes.push(context, SetupScreen());
      } else if (response.statusCode == 401) {
        await checkOtp(
            context: context, email: email, otpController: otpController);
      } else if (response.statusCode == 400) {
        log('Invalid OTP: ${response.body}');
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Invalid OTP'),
              content: Text('Please enter a valid OTP'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    // otpController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Retry'),
                ),
              ],
            );
          },
        );
      } else {
        log('Error: ${response.statusCode}');
        log('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringConstants.wrong)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error, please try again')),
      );
    }
  }
}

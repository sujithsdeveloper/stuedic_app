import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuedic_app/APIs/API_response.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/APIs/api_services.dart';
import 'package:stuedic_app/model/auth/login_response_model.dart';
import 'package:stuedic_app/model/auth/registration_response_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/refreshTocken.dart';
import 'package:stuedic_app/view/auth/login_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_nav_screen.dart';

class AuthController extends ChangeNotifier {
  bool isLoginLoading = false;

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    Map loginDetails = {"email": email, "password": password};

    try {
      isLoginLoading = true;
      notifyListeners();
      var response = await http.post(APIs.loginUrl,
          body: jsonEncode(loginDetails), headers: ApiServices.getHeaders());

      if (response.statusCode == 200) {
        LoginModel loginModelResponse = loginModelFromJson(response.body);
        final preff = await SharedPreferences.getInstance();
        // preff.setString(StringConstants.currentUserID, loginModelResponse.);
        preff.setString(StringConstants.refreshToken,
            loginModelResponse.refreshToken ?? '');

        preff
            .setString(
                StringConstants.accessToken, loginModelResponse.token ?? '')
            .then(
          (value) {
            AppRoutes.pushAndRemoveUntil(
                context,
                BottomNavScreen(
                  isColege: true,
                ));
          },
        );
        log(response.body);
      } else if (response.body.contains(ApiResponse.userNotFound)) {
        errorSnackbar(label: 'User Not Found', context: context);
      } else if (response.body.contains(ApiResponse.invalidPassword)) {
        errorSnackbar(label: 'Invalid Password', context: context);
      } else {
        log(response.statusCode.toString());
      }

      isLoginLoading = false;
      notifyListeners();
    } catch (e) {
      errorSnackbar(label: e.toString(), context: context);
      isLoginLoading = false;
      notifyListeners();
    }
  }

  Future<void> logoutUser({required BuildContext context}) async {
    String? refreshToken = await AppUtils.getToken(isRefreshToken: true);
    Map data = {"refresh_token": refreshToken};

    try {
      var response = await http.post(APIs.logoutUser,
          headers: ApiServices.getHeadersWithToken(refreshToken),
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        AppUtils.deleteToken().then(
          (value) {
            AppRoutes.pushAndRemoveUntil(context, LoginScreen());
          },
        );
      } else {
        // log(response.body);
        errorSnackbar(label: "Something went wrong", context: context);
      }
    } catch (e) {
      log(e.toString());
      errorSnackbar(label: e.toString(), context: context);
    }
  }

  RegistrationModel? registrationModel;
  Future<void> createAccount(
      {required BuildContext context,
      required String email,
      required String userName,
      required String collegeName,
      required String phoneNumber,
      required String collegeIDUrl,
      required String password,
      required String role}) async {
    final data = {
      "email": email,
      "userName": userName,
      "collageName": collegeName,
      "phone": phoneNumber,
      "collageIDurl": collegeIDUrl,
      "password": password,
      "role": role,
      "Phone": "234567890"
    };

    try {
      var response = await http.post(APIs.onBoardUrl,
          body: jsonEncode(data), headers: ApiServices.getHeaders());

      if (response.statusCode == 200) {
        registrationModel = registrationModelFromJson(response.body);
        notifyListeners();
        await AppUtils.saveToken(
            accessToken: registrationModel?.token ?? '',
            refreshToken: registrationModel?.refreshToken ?? '');
        AppRoutes.pushAndRemoveUntil(context, BottomNavScreen());
      } else if (response.statusCode == 401) {
        await refreshAccessToken(context: context);
        createAccount(
            context: context,
            email: email,
            userName: userName,
            collegeName: collegeName,
            phoneNumber: phoneNumber,
            collegeIDUrl: collegeIDUrl,
            password: password,
            role: role);
      } else if (response.body.contains(ApiResponse.userAlreadyExist)) {
        errorSnackbar(
            label: 'User with this email already exists', context: context);
      }
    } catch (e) {
      log(e.toString());
      errorSnackbar(label: StringConstants.wrong, context: context);
    }
  }
}

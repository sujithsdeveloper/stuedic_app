
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/refresh_token_model.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';

Future<void> refreshAccessToken({required BuildContext context}) async {
  String? token = await AppUtils.getToken(isRefreshToken: true);
  var response = await http.get(APIs.grantAccessTokenUrl, headers: {
    'Content-Type': 'application/json',
    "Authorization": "Bearer $token"
  });

  try {
    if (response.statusCode == 200) {
      final resModel = refreshTokenModelFromJson(response.body);
      // prefs.setString('', resModel.token??'');
      final prefs = await SharedPreferences.getInstance();  
      prefs.setString('token', resModel.token ?? '');
      prefs.setString('refreshToken', resModel.refreshToken ?? '');
    
    }
  } catch (e) {
    errorSnackbar(label: e.toString(), context: context);
  }
}

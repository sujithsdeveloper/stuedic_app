import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';


Future<void> refreshAccessToken({required BuildContext context}) async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('refreshToken');
  var response = await http.get(APIs.grantAccessTokenUrl, headers: {
    'Content-Type': 'application/json',
    "Authorization": "Bearer $token"
  });

  try {
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final newAccessToken = responseData['token'];
      final newRefreshToken = responseData['refreshToken'];
      prefs.setString('token', newAccessToken);
      if (newRefreshToken != null) {
        prefs.setString('refreshToken', newRefreshToken);
      }
    }
  } catch (e) {
errorSnackbar(label: e.toString(), context: context);
  }
}

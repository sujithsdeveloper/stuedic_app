import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';

class UploadProfileImageController extends ChangeNotifier {
  String? imgUrl;
  Future<void> uploadProfile(
      {required BuildContext context, required File Image}) async {
    String? token = await AppUtils.getToken();
    try {
      var request = http.MultipartRequest('POST', APIs.uploadProfile);
      request.files.add(await http.MultipartFile.fromPath('file', Image.path));

      request.headers['Authorization'] = 'Bearer $token';
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        var response = await http.Response.fromStream(streamedResponse);
        var decodedResponse = jsonDecode(response.body);
        log('Image uploaded successfully.');
        imgUrl = decodedResponse['fullUrl'];
        notifyListeners();
        Logger().f('Image URL: $imgUrl');
      }
    } catch (e) {
      errorSnackbar(label: 'Failed to upload image', context: context);
    }
  }
}

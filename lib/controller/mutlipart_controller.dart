import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/refreshTocken.dart';

class MutlipartController extends ChangeNotifier {
  Future<String> uploadMedia(
      {required BuildContext context,
      required String filePath,
      required Uri API,
      bool isVideo = false}) async {
    try {
      String? token = await AppUtils.getToken();
      var request = http.MultipartRequest('POST', API);

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      request.headers['Authorization'] = 'Bearer $token';
      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await http.Response.fromStream(streamedResponse);
        var decodedResponse = jsonDecode(response.body);

        if (isVideo) {
          String videoUrl = decodedResponse['hlsUrl'];
          Logger().d('video uploaded successfully: $videoUrl');

          return videoUrl;
        } else {
          String imgUrl = decodedResponse['fullUrl'];

          Logger().f('Image uploaded successfully: $imgUrl');
          return imgUrl;
        }
      } else if (streamedResponse.statusCode == 401) {
        await refreshAccessToken(context: context);

        return await uploadMedia(
            context: context, API: API, filePath: filePath);
      } else {
        var errorResponse = await http.Response.fromStream(streamedResponse);
        Logger().e(
            'Failed to upload image. Server response: ${errorResponse.body}');

        return '';
      }
    } catch (e) {
      Logger().e(e.toString());
      errorSnackbar(label: e.toString(), context: context);
      return '';
    }
  }
}

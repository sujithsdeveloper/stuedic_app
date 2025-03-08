import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/refreshTocken.dart';

class MutlipartController extends ChangeNotifier {
  String? imageUrl;
  bool isUploading = false;
  Future<void> uploadMedia({
    required BuildContext context,
    required String filePath,
    required Uri API,
    bool isVideo = false,
  }) async {
    try {
      log('Uploading media...');
      isUploading = true;
      notifyListeners();
      String? token = await AppUtils.getToken();
      var request = http.MultipartRequest('POST', API);
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.headers['Authorization'] = 'Bearer $token';

      var streamedResponse = await request.send();
      log('Response code: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode == 200) {
        isUploading = false;
        notifyListeners();
        var response = await http.Response.fromStream(streamedResponse);
        var decodedResponse = jsonDecode(response.body);

        if (isVideo) {
          String videoUrl = decodedResponse['hlsUrl'];
          Logger().d('Video uploaded successfully: $videoUrl');
        } else {
          log('Image uploaded successfully.');
          String imgUrl = decodedResponse['fullUrl'];
          Logger().f('Image URL: $imgUrl');
          imageUrl = imgUrl;
          notifyListeners();
        }
      } else if (streamedResponse.statusCode == 401) {
        isUploading = false;
        notifyListeners();
        await refreshAccessToken(context: context);
        return await uploadMedia(
            context: context, API: API, filePath: filePath);
      } else if (streamedResponse.statusCode == 413) {
        isUploading = false;
        notifyListeners();
        errorSnackbar(
            label: 'Failed to upload. File is too large', context: context);

        // Remove selected image
        final assetPicker = context.read<AssetPickerController>();
        assetPicker.pickedImage = null;
        assetPicker.notifyListeners();
      } else {
        isUploading = false;
        notifyListeners();
        var errorResponse = await http.Response.fromStream(streamedResponse);
        log(errorResponse.body);
      }
    } catch (e) {
      isUploading = false;
      notifyListeners();
      Logger().e(e.toString());
      errorSnackbar(label: 'Error: ${e.toString()}', context: context);
    }
  }
}

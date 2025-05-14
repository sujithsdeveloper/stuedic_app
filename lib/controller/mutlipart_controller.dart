import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/refreshTocken.dart';

class MutlipartController extends ChangeNotifier {
  String? imageUrl;
  String? videoUrl;
  bool isUploading = false;
  Future<void> uploadMedia({
    required BuildContext context,
    required String filePath,
    required Uri API,
    bool isVideo = false,
  }) async {
    AppUtils.showToast(toastMessage: 'Uploading media...');
    log('Uploading media...');
    try {
      if (filePath == null) {
        log('null file path');
        errorSnackbar(label: 'File is empty', context: context);
        return;
      }
      isUploading = true;

      log('Uploading media...isUploading: $isUploading');
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
        log('Response body: ${response.body}', name: 'Multipart Response');
        var decodedResponse = jsonDecode(response.body);

        if (isVideo) {
          videoUrl = decodedResponse['hlsUrl'];
          log('Video uploaded successfully: $videoUrl');
        } else {
          log('Image uploaded successfully.');
          String imgUrl = decodedResponse['fullUrl'];
          log('Image URL: $imgUrl');
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
        log("Multipart Error ${errorResponse.body}");
      }
    } catch (e) {
      isUploading = false;
      notifyListeners();
      Logger().e(e.toString());
      errorSnackbar(label: 'Error: ${e.toString()}', context: context);
    }
  }

  Future<String?> uploadVideo(
      {File? file, required BuildContext context}) async {
    AppUtils.showToast(toastMessage: 'Uploading media...');
    log('Uploading media...');
    if (file == null) {
      log('null file path');
      AppUtils.showToast(toastMessage: 'File is Empty');
      return null;
    }

    isUploading = true;
    notifyListeners();

    try {
      String? token = await AppUtils.getToken();
      var request = http.MultipartRequest('POST', ApiUrls.uploadVideo);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers['Authorization'] = 'Bearer $token';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      // log('Response body: ${response.body}', name: 'Multipart Response');
      var decodedResponse = jsonDecode(response.body);

      if (streamedResponse.statusCode == 200) {
        videoUrl = decodedResponse['hlsUrl'];
        log(response.body, name: 'Multipart Response');
        log('Video uploaded successfully: $videoUrl');
        isUploading = false;
        notifyListeners();
        return videoUrl;
      } else if (streamedResponse.statusCode == 401) {
        isUploading = false;
        notifyListeners();
        await refreshAccessToken(context: context);
        // Retry upload after refreshing token
        return await uploadVideo(context: context, file: file);
      } else if (streamedResponse.statusCode == 413) {
        isUploading = false;
        notifyListeners();

        errorSnackbar(
            label: 'Failed to upload. File is too large', context: context);
        // Remove selected video
        final assetPicker = context.read<AssetPickerController>();
        assetPicker.pickedVideo = null;
        assetPicker.notifyListeners();
        return null;
      } else {
        isUploading = false;
        notifyListeners();
        log("Multipart Error ${response.body}");
        errorSnackbar(label: 'Failed to upload video', context: context);
        return null;
      }
    } catch (e) {
      isUploading = false;
      notifyListeners();
      Logger().e(e.toString());
      errorSnackbar(label: 'Error: ${e.toString()}', context: context);
      return null;
    }
  }
}

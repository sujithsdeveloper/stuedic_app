import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class StorageController extends ChangeNotifier {
  Future<void> saveNetworkImage({
    required String imageUrl,
    required BuildContext context,
    required String username,
  }) async {
    try {
      log('fun called');

      // Request permission
      // if (await _requestPermission()) {
      //   // Download the image as bytes
      //   Response<List<int>> response = await Dio().get<List<int>>(
      //     imageUrl,
      //     options: Options(responseType: ResponseType.bytes),
      //   );

      //   // Convert to Uint8List
      //   Uint8List imageData = Uint8List.fromList(response.data!);

      //   // Save image to gallery
      //   final result = await ImageGallerySaver.saveImage(
      //     imageData,
      //     name: 'Stuedic_${DateTime.now().microsecondsSinceEpoch}',
      //   );

      //   log('Image saved: $result');
      // } else {
      //   log('Permission denied');
      // }
    } catch (e) {
      log('Error saving image: $e');
    }
  }

  // Future<bool> _requestPermission() async {
  //   PermissionStatus status = await Permission.storage.request();
  //   return status.isGranted;
  // }
}

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';

class AssetPickerController extends ChangeNotifier {

  File? pickedImage;
  File? pickedVideo;
  Future<void> pickMedia({
    bool isVideo = false,
    required BuildContext context,
    required ImageSource source,
  }) async {
    final picker = ImagePicker();
    if (isVideo) {
      final video = await picker.pickVideo(source: source);
      if (video != null) {
        pickedVideo = File(video.path);
        notifyListeners();
        log('Picked video path ${pickedVideo.toString()}');
        try {
          await context.read<MutlipartController>().uploadMedia(
              context: context,
              isVideo: true,
              filePath: video.path,
              API: APIs.uploadVideo);
          notifyListeners();
          Navigator.pop(context);
        } catch (e) {
          errorSnackbar(label: 'Failed to upload video', context: context);
        }
      } else {
        errorSnackbar(label: 'No video selected', context: context);
      }
    } else {
      final image = await picker.pickImage(source: source);
      if (image != null) {
        pickedImage = File(image.path);
        try {
          await context.read<MutlipartController>().uploadMedia(
              context: context,
              isVideo: false,
              filePath: image.path,
              API: APIs.uploadPicForPost);
          notifyListeners();
          Navigator.pop(context);
        } catch (e) {
          log("Error converting image: $e");
          errorSnackbar(label: "Error processing image", context: context);
        }
      } else {
        errorSnackbar(label: "No image selected", context: context);
      }
    }
  }
}

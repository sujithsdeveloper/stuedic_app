import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/image/image_edit_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';

class AssetPickerController extends ChangeNotifier {
  File? pickedImage;
  File? pickedVideo;
  bool isLoading = false;
  Future<void> pickMedia({
    bool isVideo = false,
    bool UplaodMedia = false,
    bool cropImage = false,
    required BuildContext context,
    required ImageSource source,
  }) async {
    final picker = ImagePicker();
    if (isVideo) {
      final video = await picker.pickVideo(source: source);
      isLoading = true;
      notifyListeners();

      if (video != null) {
        pickedVideo = File(video.path);
        notifyListeners();

        log('Picked video path ${pickedVideo.toString()}');

        if (context.mounted && UplaodMedia) {
          await context.read<MutlipartController>().uploadMedia(
                context: context,
                isVideo: true,
                filePath: video.path,
                API: APIs.uploadVideo,
              );
        }
      } else {
        if (context.mounted) {
          errorSnackbar(label: 'No video selected', context: context);
        }
      }
    } else {
      isLoading = true;
      notifyListeners();

      final image = await picker.pickImage(source: source);
      if (image != null) {
        pickedImage = File(image.path);
        notifyListeners();

        log('Picked image path: ${pickedImage?.path}');

        if (cropImage) {
          log('crop called');
          await context.read<ImageEditController>().cropImage(
                image: pickedImage!,
                context: context,
              );
        }
      } else {
        if (context.mounted) {
          errorSnackbar(label: "No image selected", context: context);
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  void clearAsset() {
    pickedImage = null;
    pickedVideo = null;
    notifyListeners();
  }
}

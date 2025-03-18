import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class ImageEditController extends ChangeNotifier {
  File? croppedImage;

  Future<void> cropImage({required File image}) async {
    // log(image.path);
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 4),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
            hideBottomControls: true,
            // aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
            backgroundColor: Colors.black,
            activeControlsWidgetColor: ColorConstants.primaryColor2),
        IOSUiSettings(
          title: 'Crop Image',
          doneButtonTitle: 'Crop',
          cancelButtonTitle: 'Cancel',
          aspectRatioLockEnabled: false,
        )
      ],
    );

    if (croppedFile != null) {
      croppedImage = File(croppedFile.path);
      notifyListeners();
    }
  }
}

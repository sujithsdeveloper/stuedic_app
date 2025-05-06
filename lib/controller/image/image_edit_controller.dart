import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class ImageEditController extends ChangeNotifier {
  File? croppedImage;
  Future<void> cropImage(
      {required File image,
      required BuildContext context,
      CropAspectRatio? ratio}) async {
    log(image.path);

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio:
          ratio == null ? CropAspectRatio(ratioX: 3, ratioY: 4) : ratio,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
          hideBottomControls: true,
          backgroundColor: Colors.black,
          activeControlsWidgetColor: ColorConstants.primaryColor2,
        ),
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

      if (context.mounted) {
        await context.read<MutlipartController>().uploadMedia(
              context: context,
              filePath: croppedFile.path,
              API: ApiUrls.uploadPicForPost,
            );
      }
    }
  }
}

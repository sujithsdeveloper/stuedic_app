import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_designer/story_designer.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';

class AssetPickerController extends ChangeNotifier {
  File? pickedImage;
  File? pickedVideo;
  bool isLoading = false;
  Future<void> pickMedia({
    bool isVideo = false,
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
        try {
          Navigator.pop(context);

          // await context.read<MutlipartController>().uploadMedia(
          //     context: context,
          //     isVideo: true,
          //     filePath: video.path,
          //     API: APIs.uploadVideo);
          notifyListeners();
        } catch (e) {
          errorSnackbar(label: 'Failed to upload video', context: context);
        }
      } else {
        errorSnackbar(label: 'No video selected', context: context);
        Navigator.pop(context);
      }
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = true;
      notifyListeners();
      final image = await picker.pickImage(source: source);
      if (image != null) {
        pickedImage = File(image.path);

        log('Picked image path: ${pickedImage?.path}');
        notifyListeners();
        Navigator.pop(context);

        // await context.read<MutlipartController>().uploadMedia(
        //     context: context,
        //     isVideo: false,
        //     filePath: pickedImage!.path,
        //     API: APIs.uploadPicForPost);
      } else {
        Navigator.pop(context);
        errorSnackbar(label: "No image selected", context: context);
      }
      isLoading = false;
      notifyListeners();
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

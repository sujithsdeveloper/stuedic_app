import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/image/image_edit_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/app_default_settings.dart';
import 'package:stuedic_app/view/screens/media/upload_video_player.dart';
import 'package:video_player/video_player.dart';

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
    log('pick media called');
    final picker = ImagePicker();
    if (isVideo) {
      final video = await picker.pickVideo(source: source);
      isLoading = true;
      notifyListeners();

      if (video != null) {
        final pickedVideoDuration = await AppUtils.getVideoDuration(video);
        final maximumVideoDuration = AppDefaultSettings.videoDuration;

        if (pickedVideoDuration > maximumVideoDuration) {
          AppUtils.showToast(
              toastMessage:
                  'Video duration should be less than ${maximumVideoDuration.inSeconds} seconds');
          log('Picked video duration: $pickedVideoDuration');
          pickedVideo = null;
          isLoading = false;
          notifyListeners();

          return;
        } else {
          pickedVideo = File(video.path);
          // log('Picked video path: ${pickedVideo?.path}');
          notifyListeners();
          // Upload video before navigating, and only use context if still mounted
          await context.read<MutlipartController>().uploadMedia(
              context: context,
              filePath: pickedVideo!.path,
              API: ApiUrls.uploadVideo,
              isVideo: true);

          // if (context.mounted) {
          //   AppRoutes.push(context, upload_video_player(file: pickedVideo!));
          // }
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
          await context
              .read<ImageEditController>()
              .cropImage(image: pickedImage!, context: context);
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

  Future<void> pickImage({
    required ImageSource source,
    CropAspectRatio? aspectRatio,
    bool showPresets = false,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    ImagePicker picker = ImagePicker();
    ImageCropper cropper = ImageCropper();

    final image = await picker.pickImage(
      source: source,
    );
    if (image != null) {
      log('Picked image path: ${image.path}');
      CroppedFile? croppedFile = await cropper.cropImage(
        sourcePath: image.path,
        aspectRatio: aspectRatio == null
            ? const CropAspectRatio(ratioX: 3, ratioY: 4)
            : aspectRatio,
        uiSettings: [
          AndroidUiSettings(
              hideBottomControls: true,
              lockAspectRatio: true,
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              toolbarTitle: 'Crop Image',
              statusBarColor: Colors.black),
          IOSUiSettings(
            aspectRatioLockEnabled: true,
          )
        ],
      );

      if (croppedFile != null) {
        log('cropped image path: ${croppedFile.path}');
        isLoading = false;
        notifyListeners();

        await context
            .read<MutlipartController>()
            .uploadMedia(
                context: context,
                filePath: croppedFile.path,
                API: ApiUrls.uploadPicForPost,
                isVideo: false)
            .then(
          (value) {
            Navigator.pop(context);
          },
        );
        pickedImage = File(croppedFile.path);
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        errorSnackbar(label: 'Image cropping canceled', context: context);
      }
    } else {
      isLoading = false;
      notifyListeners();
      errorSnackbar(label: 'No Image Selected', context: context);
    }
  }

  Future<void> pickImageForPost(
      {required ImageSource imageSource, required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    final imagePicker = ImagePicker();
    final image =
        File((await imagePicker.pickImage(source: imageSource))?.path ?? '');
    if (image != null) {
      isLoading = false;
      notifyListeners();
      context
          .read<ImageEditController>()
          .cropPostImage(image, showRatioPresets: true)
          .then((value) {
        if (value != null) {
          pickedImage = value;
          context.read<MutlipartController>().uploadMedia(
              context: context,
              filePath: pickedImage!.path,
              API: ApiUrls.uploadPicForPost,
              isVideo: false);
          notifyListeners();
        }
      });
    } else {
      isLoading = false;
      notifyListeners();
      errorSnackbar(label: 'No Image Selected', context: context);
    }
  }

  Future<File?> pickVideoForPost(
      {required ImageSource imageSource, required BuildContext context}) async {
    log('pick video for post called');
    isLoading = true;
    notifyListeners();
    final imagePicker = ImagePicker();
    final videoXfile = await imagePicker.pickVideo(source: imageSource);
    if (videoXfile != null) {
      final videoFile = File(videoXfile.path);
      log('picked video path: ${videoFile.path}');
      isLoading = false;
      notifyListeners();

      final VideoPlayerController videoPlayerController =
          VideoPlayerController.file(videoFile);
      log('Picked video duration: ${videoPlayerController.value.duration}');

      if (videoPlayerController.value.duration >
          AppDefaultSettings.videoDuration) {
        AppUtils.showToast(
            toastMessage:
                'Video duration should be less than ${AppDefaultSettings.videoDuration.inSeconds} seconds');
        log('Picked video duration: ${videoPlayerController.value.duration}');
        pickedVideo = null;
        isLoading = false;
        notifyListeners();
        return null;
      } else {
        log('Video duration is within limit');
        pickedVideo = videoFile;
        notifyListeners();
        final videoUrl = await context.read<MutlipartController>().uploadVideo(
              context: context,
              file: pickedVideo!,
            );
        log('Video URL: $videoUrl');
        return videoFile;
      }
    }
  }
}

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class MediaController extends ChangeNotifier {
  List<AssetEntity> mediaList = [];
  List<AssetEntity> selectedMediaList = [];
  int selectedIndex = 0;
  AssetEntity? selectedMedia;
  Map<AssetEntity, Uint8List?> mediaThumbnails = {};

  Future<void> fetchMedia() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();

    if (permission.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(type: RequestType.common);

      if (albums.isNotEmpty) {
        mediaList = await albums.first.getAssetListPaged(page: 0, size: 200);

        for (var media in mediaList) {
          mediaThumbnails[media] =
              await media.thumbnailDataWithSize(const ThumbnailSize(200, 200));
        }

        notifyListeners();
      }
    } else {
      PhotoManager.openSetting();
    }
  }

  bool isCover = false;
  changeImageFit() {
    isCover = !isCover;

    notifyListeners();
  }

  void toggleSelection(AssetEntity media, int index) {
    isCover = false;
    if (selectedMedia == media) {
    } else {
      selectedMedia = media;
      selectedIndex = index;
    }
    notifyListeners();
  }

  bool onPop() {
    selectedMediaList.clear();
    return true;
  }

  void initialiseVideo(
      {required VideoPlayerController controller, required File file}) {
    controller = VideoPlayerController.file(file)..initialize();
  }

  bool isPlaying = false;
  void togglePlayPause({required VideoPlayerController controller}) {
    if (isPlaying) {
      controller.pause();
      isPlaying = false;
      notifyListeners();
    } else {
      controller.play();
      isPlaying = true;
      notifyListeners();
    }
  }
}

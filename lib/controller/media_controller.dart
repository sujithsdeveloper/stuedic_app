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
  List<AssetPathEntity> albums = [];
  AssetPathEntity? selectedAlbum;
  AssetEntity? selectedMedia;
  Map<AssetEntity, Uint8List?> mediaThumbnails = {};
  Future<void> fetchMedia() async {
    List<AssetPathEntity> fetchedAlbums = await PhotoManager.getAssetPathList();

    if (fetchedAlbums.isNotEmpty) {
      albums = fetchedAlbums;

      // Set default album if none is selected
      if (selectedAlbum == null) {
        selectedAlbum = albums.first;
      }

      notifyListeners();
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

  bool isLoading = false;
  Future<void> loadMediaFromAlbum(AssetPathEntity album) async {
    isLoading = true;
    notifyListeners();
    mediaList = await album.getAssetListPaged(page: 0, size: 200);
    mediaThumbnails.clear();
    for (var media in mediaList) {
      mediaThumbnails[media] =
          await media.thumbnailDataWithSize(const ThumbnailSize(200, 200));
    }
    selectedAlbum = album;
    isLoading = false;
    notifyListeners();
  }
}

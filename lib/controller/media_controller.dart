import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaController extends ChangeNotifier {
  List<AssetEntity> mediaList = [];
  File? file;
  List<AssetEntity> selectedMediaList = [];
  int selectedIndex = 0;
  List<AssetPathEntity> albums = [];
  AssetPathEntity? selectedAlbum;
  AssetEntity? selectedMedia;

  Map<AssetEntity, Uint8List?> mediaThumbnails = {};
  Future<void> fetchMedia() async {
    log('function called');
    List<AssetPathEntity> fetchedAlbums = await PhotoManager.getAssetPathList();

    if (fetchedAlbums.isNotEmpty) {
      albums = fetchedAlbums;

      if (selectedAlbum == null) {
        selectedAlbum = albums.first;
      }

      notifyListeners();
    } else {
      log('Alubum is empty');
    }
  }



  Future<void> toggleSelection(AssetEntity media, int index) async {
    if (selectedMedia == media) {
    } else {
      selectedMedia = media;
      file = await media.file;
      selectedIndex = index;
    }
    notifyListeners();
  }

  bool onPop(PageController controller) {
    selectedMediaList.clear();

    controller.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    return false;
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

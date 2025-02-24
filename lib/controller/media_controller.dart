import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

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
        List<AssetEntity> media =
            await albums.first.getAssetListPaged(page: 0, size: 100);

        mediaList = media;

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

  void toggleSelection(AssetEntity media, int index) {
    selectedIndex = index;
    notifyListeners();
    if (selectedMediaList.contains(media)) {
      if (selectedIndex == index) {
      } else {
        selectedMediaList.remove(media);
      }
    } else {
      selectedMediaList.add(media);
    }
    notifyListeners();
  }

  bool onPop() {
    selectedMediaList.clear();
    return true;
  }
}

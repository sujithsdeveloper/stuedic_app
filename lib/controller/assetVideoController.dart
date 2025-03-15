import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Assetvideocontroller extends ChangeNotifier {
  double pickedVideoRatio = 9 / 18;

  void initialiseVideo(
      {required VideoPlayerController controller, required File file}) {
    controller = VideoPlayerController.file(file)..initialize().then((value) {
          pickedVideoRatio = controller.value.size.aspectRatio;
          notifyListeners();
      
    },);
  }

  bool isPlaying = false;
  void togglePlayPause({required VideoPlayerController controller}) {
    if (isPlaying) {
      controller.pause();

      isPlaying = false;
      notifyListeners();
    } else {
      controller.play();
      controller.setLooping(true);
      isPlaying = true;
      notifyListeners();
    }
  }
}

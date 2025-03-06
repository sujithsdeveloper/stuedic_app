import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Assetvideocontroller extends ChangeNotifier {

  
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Assetvideocontroller extends ChangeNotifier {
  void initialiseVideo(
      {required VideoPlayerController controller, required File file}) {
    controller = VideoPlayerController.file(file)..initialize();
    
  }
}

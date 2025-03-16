import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PickerVideoController extends ChangeNotifier {

  late VideoPlayerController controller;

  void initVideo({required File file}){
controller=VideoPlayerController.file(file)..initialize();
  }

void onTap(){
  if (controller.value.isPlaying) {
    controller.pause();
  }
  else{
    controller.play();
  }
}

}
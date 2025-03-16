import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoTypeController extends ChangeNotifier {
  double pickedVideoRatio = 9 / 18;

  late VideoPlayerController controller;

  void initialiseAssetVideo({required File file}) {
    controller = VideoPlayerController.file(file)
      ..initialize().then(
        (value) {
          pickedVideoRatio = controller.value.size.aspectRatio;
          notifyListeners();
        },
      );
  }

  void initialiseNetworkVideo(
      {required String url, bool inistatePlay = false}) {
    controller = VideoPlayerController.network(url)..initialize();
    if (inistatePlay) {
      controller.play();
      controller.setLooping(true);
    }
  }

  void onTap(
      {bool isGestureControll = false,
      required VideoPlayerController controller}) {
    if (isGestureControll) {
      toggleMuteUnmute();
    } else {
      togglePlayPause();
    }
  }

  void onLongPress() {
    controller.pause();
    notifyListeners();
  }

  void onLongPressEnd() {
    controller.play();
    notifyListeners();
  }

  bool isMuted = false;
  void toggleMuteUnmute() {
    if (isMuted) {
      controller.setVolume(1);
      isMuted = false;
      notifyListeners();
    } else {
      controller.setVolume(0);
      isMuted = true;
      notifyListeners();
    }
  }

  bool isPlaying = false;
  void togglePlayPause() {
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

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShortsController extends ChangeNotifier {
  late VideoPlayerController videoController;
  bool isInitialised = false;

  void initialiseVideo({required String url}) {
    videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        isInitialised = true;
        notifyListeners();
        videoController.play();
        videoController.setLooping(true);
      });
  }

  void onLongPress() {
    if (videoController.value.isPlaying) {
      videoController.pause();
    }
  }

  void onLongPressEnd() {
    if (!videoController.value.isPlaying) {
      videoController.play();
    }
  }
}

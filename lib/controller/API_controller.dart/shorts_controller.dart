import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShortsController extends ChangeNotifier {
  late VideoPlayerController videoController;
  bool isInitialised = false;
  bool isBuffering = true; // Initially true because the video is loading

  void initialiseVideo({required String url}) {
    videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..addListener(() {
        // Listen for buffering state
        if (videoController.value.isBuffering != isBuffering) {
          isBuffering = videoController.value.isBuffering;
          notifyListeners();
        }
      })
      ..initialize().then((_) {
        isInitialised = true;
        isBuffering = false; // Initialization complete, stop buffering
        notifyListeners();
        videoController.play();
        videoController.setLooping(true);
      }).catchError((error) {
        print("Video initialization error: $error");
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

  void disposeVideo() {
  if (videoController.value.isInitialized) {
    videoController.pause();
    videoController.dispose();
  }
}

}

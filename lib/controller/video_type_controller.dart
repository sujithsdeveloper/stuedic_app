import 'dart:io';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoTypeController extends ChangeNotifier {
  double pickedVideoRatio = 9 / 18;
  bool volume_mute = true;

  VideoPlayerController? networkVideoController;
  VideoPlayerController? assetVideoController;

  void initialiseAssetVideo({required File file}) {
    assetVideoController = VideoPlayerController.file(file)
      ..initialize().then(
        (value) {
          pickedVideoRatio = assetVideoController!.value.size.aspectRatio;
          notifyListeners();
        },
      );
  }

  void initialiseNetworkVideo(
      {required String url, bool inistatePlay = false}) {
    networkVideoController = VideoPlayerController.network(url)..initialize();
    if (inistatePlay) {
      networkVideoController!.play();
      networkVideoController!.setLooping(true);
    }
  }

  void onTap(
      {bool isGestureControll = false,
      required VideoPlayerController controller}) {
    if (isGestureControll) {
      toggleMuteUnmute();
    } else {
      togglePlayPause(controller);
    }
  }

  void onLongPress(VideoPlayerController controller) {
    controller.pause();
    notifyListeners();
  }

  void onLongPressEnd(VideoPlayerController controller) {
    controller.play();
    notifyListeners();
  }

  bool isMuted = false;
  void toggleMuteUnmute() {
    if (isMuted) {
      networkVideoController!.setVolume(1);
      isMuted = false;
      notifyListeners();
    } else {
      networkVideoController!.setVolume(0);
      isMuted = true;
      notifyListeners();
    }
  }

  bool isPlaying = false;
  void togglePlayPause(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
      isPlaying = false;
      notifyListeners();
    } else {
      controller.play();
      isPlaying = true;
      notifyListeners();
    }
  }

  void volumeButtonClick(VideoPlayerController controller) {
    if (volume_mute) {
      volume_mute = false;
      controller.setVolume(0.0);
      notifyListeners();
    } else {
      volume_mute = true;
      controller.setVolume(1.0);
      notifyListeners();
    }
  }
}

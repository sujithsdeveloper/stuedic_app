import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoTrimController extends ChangeNotifier {
  double videoStartValue = 0.0;
  double videoEndValue = 0.0;
  bool isPlaying = false;
  final Trimmer trimmer = Trimmer();
  Future<void> loadVideo({required File file}) async {
    await trimmer.loadVideo(videoFile: file);
  }

  void trimVideo() {}

  void onChangeStart(double startValue) {
    videoStartValue = startValue;
    notifyListeners();
  }

  void onChangeEnd(double endValue) {
    videoEndValue = endValue;
    notifyListeners();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

class VideoTrimController extends ChangeNotifier {
  double videoStartValue = 0.0;
  double videoEndValue = 0.0;
  bool isPlaying = false;
  String? videoOutputPath;

  void loadVideo({required File file}) async {
    // await trimmer.loadVideo(videoFile: file);
    notifyListeners();
  }

  void setStartValue(double value) {
    videoStartValue = value;
    notifyListeners();
  }

  void setEndValue(double value) {
    videoEndValue = value;
    notifyListeners();
  }

  void setPlayingState(bool playing) {
    isPlaying = playing;
    notifyListeners();
  }

  Future<void> trimVideo() async {
    // final outputPath = await trimmer.saveTrimmedVideo(
    //   startValue: videoStartValue,
    //   endValue: videoEndValue,
    //   storageDir: StorageDir.temporaryDirectory,
    //   onSave: (outputPath) {
    //     videoOutputPath = outputPath;
    //     notifyListeners();
    //   },
    // );
  }
}

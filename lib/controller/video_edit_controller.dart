import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

class VideoEditController extends ChangeNotifier {
  // final Trimmer trimmer = Trimmer();
  // double startValue = 0.0;
  // double endValue = 30.0;
  // bool isVideoLoaded = false;

  // Future<void> loadPickedVideo(File file) async {
  //   try {
  //     log("Loading video: ${file.path}");
  //     await trimmer.loadVideo(videoFile: file);
  //     isVideoLoaded = true;
  //     notifyListeners();
  //     log("Video loaded successfully");
  //   } catch (e) {
  //     log("Error loading video: $e");
  //   }
  // }

  // Future<String?> saveTrimmedVideo() async {
  //   String? outputPath;
  //   await trimmer.saveTrimmedVideo(
  //     startValue: startValue,
  //     endValue: endValue,
  //     onSave: (path) {
  //       outputPath = path;
  //     },
  //   );
  //   return outputPath;
  // }

  // void setStartValue(double value) {
  //   startValue = value;
  //   notifyListeners();
  // }

  // void setEndValue(double value) {
  //   endValue = value;
  //   notifyListeners();
  // }

  // @override
  // void dispose() {
  //   trimmer.dispose();
  //   super.dispose();
  // }
}

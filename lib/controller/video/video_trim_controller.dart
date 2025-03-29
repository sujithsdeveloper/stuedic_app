import 'dart:io';

import 'package:flutter/material.dart';

class VideoTrimController extends ChangeNotifier {
  double videoStartValue = 0.0;
  double videoEndValue = 0.0;
  bool isPlaying = false;
  String? videoOutputPath;

}

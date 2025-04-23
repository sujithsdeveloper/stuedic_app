import 'package:flutter/material.dart';

class ScrollingController extends ChangeNotifier {
  bool gridViewScrollEnabled = false;

  void controllerScroll({required ScrollController scrollController}) {
    scrollController.addListener(() {
      // Customize this value according to SliverAppBar height
      if (scrollController.offset >= 250 && !gridViewScrollEnabled) {
        gridViewScrollEnabled = true;
        notifyListeners();
      } else if (scrollController.offset < 250 && gridViewScrollEnabled) {
        gridViewScrollEnabled = false;
        notifyListeners();
      }
    });
  }
}

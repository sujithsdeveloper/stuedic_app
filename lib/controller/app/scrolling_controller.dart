import 'package:flutter/material.dart';

class ScrollingController extends ChangeNotifier {
  int pageCount = 1;
  bool isDataLoading = false;

  void listenToScroll(
      {required ScrollController scrollController,
      required Function() onScrollEnd}) {
    scrollController.addListener(() {
      if (isDataLoading) return;
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        isDataLoading = true;
        pageCount += 1;
        notifyListeners();
        onScrollEnd();
      }
    });
  }

  void resetPageCount() {
    pageCount = 1;
    notifyListeners();
  }
}

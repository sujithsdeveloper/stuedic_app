import 'package:flutter/material.dart';

class HomePageController extends ChangeNotifier {
  PageController? pageController;
  void HomePageControl() {
    pageController = PageController(
      initialPage: 0,
      keepPage: false,
    );
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';

class LikeController extends ChangeNotifier {
  bool isLiked = false;
  int countLike = 0;

  void likebool({required bool likebool, required int likeCount}) {
    if (likebool) {
      isLiked = !likebool;
      countLike = likeCount--;
      notifyListeners();
    } else {
      isLiked = !likebool;
      countLike = likeCount++;
      notifyListeners();
    }
  }
}

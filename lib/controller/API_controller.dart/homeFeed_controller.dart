import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/home_feed_model.dart';

class HomefeedController extends ChangeNotifier {
  bool isHomeFeedLoading = false;
  HomeFeed? homeFeed;
  Future<void> getAllPost({required BuildContext context}) async {
    isHomeFeedLoading = true;
    notifyListeners();
    await ApiMethods.get(
        url: APIs.homeFeedAPI,
        onSucces: (p0) {
          homeFeed = homeFeedFromJson(p0.body);
          isHomeFeedLoading = false;
          notifyListeners();
          // log('home feed: ${p0.body}');
        },
        onTokenExpired: () {
          isHomeFeedLoading = false;
          notifyListeners();
          getAllPost(context: context);
        },
        context: context);
    isHomeFeedLoading = false;
    notifyListeners();
  }

  bool showShimmer = false;

  void changeShimmer() {
    showShimmer = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      showShimmer = false;
      notifyListeners();
    });
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/home_feed_model.dart';

class HomefeedController extends ChangeNotifier {
  HomeFeed? homeFeed;
  void getAllPost({required BuildContext context}) {
    ApiCall.get(
        url: APIs.homeFeedAPI,
        onSucces: (p0) {
          homeFeed = homeFeedFromJson(p0.body);
          notifyListeners();
          // log(p0.body);
        },
        onTokenExpired: () {
          getAllPost(context: context);
        },
        context: context);
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';

class StoryController extends ChangeNotifier {
  bool isStoryUploading = false;
  Future<void> addStory(
      {required BuildContext context,
      required String url,
      required String caption}) async {
    final data = {"contentURL": url, "caption": caption};
    isStoryUploading = true;
    notifyListeners();
    await ApiCall.post(
        url: APIs.addStory,
        body: data,
        onSucces: (p0) {
          isStoryUploading = false;
          notifyListeners();
          log(p0.body);
          customSnackbar(label: 'Story added', context: context);
          Navigator.pop(context);
        },
        onTokenExpired: () {
          isStoryUploading = false;
          notifyListeners();
          addStory(context: context, url: url, caption: caption);
        },
        context: context);
  }

  void getStories({required BuildContext context}) {}
}

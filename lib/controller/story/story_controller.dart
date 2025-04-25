import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/APIs/api_services.dart';
import 'package:stuedic_app/model/get_story_model.dart';

class StoryController extends ChangeNotifier {
  HomeStoriesModel? getstorymodel;
  Future<void> getStories(BuildContext context) async {
    await ApiMethods.get(
        url: ApiUrls.getStoryList,
        onSucces: (p0) {
          getstorymodel = homeStoriesModelFromJson(p0.body);
          notifyListeners();
        },
        onTokenExpired: () async {
          await getStories(context);
        },
        context: context);
  }

  bool isStoryUploading = false;

  Future<void> addStory(
      {required String url,
      required String caption,
      required BuildContext context}) async {
    isStoryUploading = true;
    notifyListeners();

    final data = {"contentURL": url, "caption": caption};
    await ApiMethods.post(
        url: ApiUrls.addStory,
        body: data,
        onSucces: (p0) {
          isStoryUploading = false;
          notifyListeners();
          log(p0.body);
          Navigator.pop(context);
        },
        onTokenExpired: () async {
          isStoryUploading = false;
          notifyListeners();
          await addStory(
            url: url,
            caption: caption,
            context: context,
          );
        },
        context: context);
    isStoryUploading = false;
    notifyListeners();
  }
}

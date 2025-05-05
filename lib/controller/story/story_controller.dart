import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/model/get_story_model.dart';

class StoryController extends ChangeNotifier {
  HomeStoriesModel? getstorymodel;
  Future<void> getStories(BuildContext context) async {
    await ApiMethods.get(
        url: ApiUrls.getStoryList,
        onSucces: (p0) {
          getstorymodel = homeStoriesModelFromJson(p0.body);
          log(getstorymodel?.response.toString() ?? '');
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
          Future.delayed(const Duration(seconds: 1), () {
            getStories(context);
          });
          notifyListeners();
          Future.delayed(
            Duration(seconds: 2),
            () {
              getStories(context);
            },
          );
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

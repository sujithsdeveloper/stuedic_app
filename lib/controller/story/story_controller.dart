import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/model/get_story_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';

class StoryController extends ChangeNotifier {
  HomeStoriesModel? getstorymodel;
  final List<GroupedStory> homeStories = [];
  Future<void> getStories(BuildContext context) async {
    final currentUserId = await AppUtils.getCurrentUserDetails(isUserId: true);

    await ApiMethods.get(
        url: ApiUrls.getStoryList,
        onSucces: (p0) {
          getstorymodel = homeStoriesModelFromJson(p0);

          // Sort groupedStories: isCurrentUser == true to the front
          if (getstorymodel?.response?.groupedStories != null) {
            getstorymodel!.response!.groupedStories!.sort((a, b) {
              if ((a.isCurrentUser ?? false) == (b.isCurrentUser ?? false))
                return 0;
              return (a.isCurrentUser ?? false) ? -1 : 1;
            });
          }

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
      String? caption,
      required BuildContext context}) async {
    isStoryUploading = true;
    notifyListeners();

    final data = {"contentURL": url, "caption": caption ?? ''};
    await ApiMethods.post(
        url: ApiUrls.addStory,
        body: data,
        onSucces: (p0) {
          isStoryUploading = false;
          // Future.delayed(const Duration(seconds: 1), () {
          //   getStories(context);
          // });
          Future.delayed(
            Duration(seconds: 2),
            () {
              getStories(context);
            },
          );
          AppUtils.showToast(toastMessage: 'Story added successfully!');

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

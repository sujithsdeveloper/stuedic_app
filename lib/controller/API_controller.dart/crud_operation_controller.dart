import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';

class CrudOperationController extends ChangeNotifier {
  Future<void> uploadPost(
      {required String imagePath,
      required String caption,
      String visibility = 'Public',
      required BuildContext context}) async {
    Map<String, dynamic> data = {
      "postContentURL": imagePath,
      "postDescription": caption,
      "postType": "pic",
      "postVisibility": "public",
      "postColor": "red"
    };

    await ApiCall.post(
        url: APIs.addPostUrl,
        body: data,
        onSucces: (p0) {
          Logger().f(p0.body);
        },
        onTokenExpired: () {},
        context: context);
  }

  bool isLiked = false;
  Future<void> likePost(
      {required String postId, required BuildContext context}) async {
    await ApiCall.get(
        url: Uri.parse('${APIs.baseUrl}api/v1/Post/likePost?postid=$postId'),
        onSucces: (p0) {
          Logger().f(p0.body);
          isLiked = true;
          notifyListeners();
        },
        onTokenExpired: () {},
        context: context);
  }

  void commentPost() {}
  void followUser() {}
  void sharePost() {}
  void deletePost() {}
}

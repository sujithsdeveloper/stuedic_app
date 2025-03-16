import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';

class CrudOperationController extends ChangeNotifier {
  Future<void> uploadPost(
      {required String mediaUrl,
      required String caption,
      String visibility = 'Public',
      String postType = 'pic',
      required BuildContext context}) async {
    Map<String, dynamic> data = {
      "postContentURL": mediaUrl,
      "postDescription": caption,
      "postType": postType,
      "postVisibility": visibility,
      "postColor": "red"
    };

    await ApiCall.post(
        url: APIs.addPostUrl,
        body: data,
        onSucces: (p0) {
          Logger().f(p0.body);
          log('Upload response code: ${p0.statusCode}');
          Navigator.pop(context);
        },
        onTokenExpired: () {},
        context: context);
  }

  void commentPost() {}
  void followUser() {}
  void sharePost() {}
  Future<void> deletePost({
    required BuildContext context,
    required String postId,
  }) async {
    final data = {"postID": postId};
    await ApiCall.delete(
        body: data,
        url: APIs.deletePost,
        onSucces: (p0) {
          log(p0.body);
        },
        onTokenExpired: () {},
        context: context);
  }
}

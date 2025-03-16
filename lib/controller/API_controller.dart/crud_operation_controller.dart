import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/utils/app_utils.dart';

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
          context.read<HomefeedController>().getAllPost(context: context);
          context
              .read<ProfileController>()
              .getCurrentUserGrid(context: context);
          Navigator.pop(context);
        },
        onTokenExpired: () {
          uploadPost(mediaUrl: mediaUrl, caption: caption, context: context);
        },
        context: context);
  }

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
          Navigator.pop(context);
          context.read<HomefeedController>().getAllPost(context: context);
          AppUtils.showToast(msg: 'Post deleted');
        },
        onTokenExpired: () {
          deletePost(context: context, postId: postId);
        },
        context: context);
  }

  void commentPost() {}
  void followUser() {}
  void sharePost() {}
}

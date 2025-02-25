import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';

class PostInteractionController extends ChangeNotifier {
  Set<int> likedPosts = {};

  void toggleLike(
      {required int index,
      required String postId,
      required BuildContext context}) {
    if (likedPosts.contains(index)) {
      likedPosts.remove(index);
      log('unliked');
      unLikePost(postId: postId, context: context);
      notifyListeners();
    } else {
      likedPosts.add(index);
      likePost(postId: postId, context: context);
      log('liked');
      notifyListeners();
    }
    notifyListeners();
  }

  bool isPostLiked(int index) {
    return likedPosts.contains(index);
  }

  Future<void> likePost(
      {required String postId, required BuildContext context}) async {
    await ApiCall.get(
        url: Uri.parse('${APIs.baseUrl}api/v1/Post/likePost?postid=$postId'),
        onSucces: (p0) {
          Logger().f(p0.body);

          notifyListeners();
        },
        onTokenExpired: () {
          likePost(postId: postId, context: context);
        },
        context: context);
  }

  void unLikePost(
      {required String postId, required BuildContext context}) async {
    await ApiCall.get(
        url: Uri.parse('${APIs.baseUrl}api/v1/Post/unlikePost?postid=$postId'),
        onSucces: (p0) {
          Logger().f(p0.body);
          notifyListeners();
        },
        onTokenExpired: () {
          unLikePost(postId: postId, context: context);
        },
        context: context);
  }




  
}

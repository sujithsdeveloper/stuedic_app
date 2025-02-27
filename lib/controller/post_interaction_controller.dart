import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/dialogs/unfollowdialog.dart';
import 'package:stuedic_app/model/get_comment_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';

class PostInteractionController extends ChangeNotifier {
  //clear datas

  void clearData() {
    likedPosts.clear();
    followers.clear();
    bookmarks.clear();
    notifyListeners();
  }

  //like
  Set<int> likedPosts = {};
  void toggleLike(
      {required int index,
      required String postId,
      required bool isLiked,
      required BuildContext context}) {
    if (likedPosts.contains(index)) {
      likedPosts.remove(index);
      log('unliked');
      unLikePost(postId: postId, context: context, index: index);
    } else {
      likedPosts.add(index);
      likePost(postId: postId, context: context);
      log('liked');
    }
    notifyListeners();
  }

  bool isPostLiked(int index) {
    if (likedPosts.contains(index)) {
      return true;
    } else {
      return false;
    }
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
      {required String postId,
      required BuildContext context,
      required int index}) async {
    await ApiCall.get(
        url: Uri.parse('${APIs.baseUrl}api/v1/Post/unlikePost?postid=$postId'),
        onSucces: (p0) {
          Logger().f(p0.body);
          likedPosts.remove(index);
          notifyListeners();
        },
        onTokenExpired: () {
          unLikePost(postId: postId, context: context, index: index);
        },
        context: context);
  }

//follow
  Set<int> followers = {};

  void toggleFollow(
      {required int index,
      required BuildContext context,
      required String userId}) {
    if (followers.contains(index)) {
      unFollowUserDialog(
          context: context,
          index: index,
          OnUnfollow: () {
            unfollowUser(userId: userId, context: context);
            followers.remove(index);
            notifyListeners();
            Navigator.pop(context);
          });
    } else {
      followers.add(index);
      followUser(userId: userId, context: context);
    }
    notifyListeners();
  }

  bool isFollowed(int index) {
    return followers.contains(index);
  }

  void followUser({required String userId, required BuildContext context}) {
    var url =
        Uri.parse('${APIs.baseUrl}api/v1/Profile/followUser?userId=$userId');
    ApiCall.get(
        url: url,
        onSucces: (p0) {
          log(p0.body);
        },
        onTokenExpired: () {
          followUser(userId: userId, context: context);
        },
        context: context);
  }

  void unfollowUser({required String userId, required BuildContext context}) {
    var url =
        Uri.parse('${APIs.baseUrl}api/v1/Profile/unfollowUser?userId=$userId');
    ApiCall.get(
        url: url,
        onSucces: (p0) {
          log(p0.body);
        },
        onTokenExpired: () {
          followUser(userId: userId, context: context);
        },
        context: context);
  }
//bookmark

  void bookmarkPost(
      {required String postId, required BuildContext context}) async {
    await ApiCall.post(
        url: Uri.parse('${APIs.baseUrl}api/v1/Post/addBookmark'),
        body: {'postid': postId},
        onSucces: (p0) {
          Logger().f(p0.body);
          notifyListeners();
        },
        onTokenExpired: () {
          bookmarkPost(postId: postId, context: context);
        },
        context: context);
  }

  Set<int> bookmarks = {};

  void toggleBookmark(
      {required int index,
      required String postId,
      required BuildContext context}) {
    if (bookmarks.contains(index)) {
      bookmarks.remove(index);
      AppUtils.showToast(msg: 'Unaved');
    } else {
      bookmarks.add(index);
      bookmarkPost(postId: postId, context: context);
      AppUtils.showToast(msg: 'Saved');
    }

    notifyListeners();
  }

  bool isBookMarked(int index) {
    return bookmarks.contains(index);
  }

  //comment
  void addComment(
      {required String postId,
      required String comment,
      required BuildContext context}) {
    Map body = {
      "content": comment,
    };
    var url = Uri.parse('${APIs.baseUrl}api/v1/Post/addcomment?postid=$postId');
    if (comment.isNotEmpty) {
      ApiCall.post(
        url: url,
        body: body,
        onSucces: (p0) {
          log(p0.body);
        },
        onTokenExpired: () {
          addComment(postId: postId, comment: comment, context: context);
        },
        context: context,
      );
    }
  }

  GetCommentsModel? getComments;
  void getComment({required BuildContext context, required String postId}) {
    var url = Uri.parse('${APIs.baseUrl}api/v1/Post/comments?postid=$postId');
    ApiCall.get(
      url: url,
      onSucces: (p0) {
        // log(p0.body);
        getComments = getCommentsModelFromJson(p0.body);
        notifyListeners();
      },
      onTokenExpired: () {
        getComment(context: context, postId: postId);
      },
      context: context,
    );
  }
}

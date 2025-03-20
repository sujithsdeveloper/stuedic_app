import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/API_controller.dart/get_singlepost_controller.dart';
import 'package:stuedic_app/dialogs/unfollowdialog.dart';
import 'package:stuedic_app/model/get_comment_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';

class PostInteractionController extends ChangeNotifier {
  Set<int> followers = {};
  Set<int> bookmarks = {};


  void toggleLike({
    required bool isLiked,
    required String postId,
    required BuildContext context,
  }) async {
    if (isLiked) {
      await unLikePost(postId: postId, context: context, );
      }
    else {
      await likePost(postId: postId, context: context);
    }
    notifyListeners();
  }


  Future<void> likePost({
    required String postId,
    required BuildContext context,
  }) async {
    await ApiCall.get(
      url: Uri.parse('${APIs.baseUrl}api/v1/Post/likePost?postid=$postId'),
      onSucces: (p0) {
        Logger().f(p0.body);
        notifyListeners();
      },
      onTokenExpired: () => likePost(postId: postId, context: context),
      context: context,
    );
  }

  Future<void> unLikePost({
    required String postId,
    required BuildContext context,
    
  }) async {
    await ApiCall.get(
      url: Uri.parse('${APIs.baseUrl}api/v1/Post/unlikePost?postid=$postId'),
      onSucces: (p0) {
        Logger().f(p0.body);
        notifyListeners();
      },
      onTokenExpired: () =>
          unLikePost(postId: postId, context: context),
      context: context,
    );
  }

  void toggleFollow({
    required int index,
    required BuildContext context,
    required String userId,
  }) {
    if (followers.contains(index)) {
      unFollowUserDialog(
        context: context,
        index: index,
        OnUnfollow: () {
          unfollowUser(userId: userId, context: context);
          followers.remove(index);
          notifyListeners();
          Navigator.pop(context);
        },
      );
    } else {
      followers.add(index);
      followUser(userId: userId, context: context);
      notifyListeners();
    }
  }

  bool isFollowed(int index) => followers.contains(index);

  void followUser(
      {required String userId, required BuildContext context}) async {
    await ApiCall.get(
      url: Uri.parse('${APIs.baseUrl}api/v1/Profile/followUser?userId=$userId'),
      onSucces: (p0) {
        Logger().f(p0.body);
        notifyListeners();
      },
      onTokenExpired: () => followUser(userId: userId, context: context),
      context: context,
    );
  }

  void unfollowUser(
      {required String userId, required BuildContext context}) async {
    await ApiCall.get(
      url: Uri.parse(
          '${APIs.baseUrl}api/v1/Profile/unfollowUser?userId=$userId'),
      onSucces: (p0) {
        Logger().f(p0.body);
        notifyListeners();
      },
      onTokenExpired: () => unfollowUser(userId: userId, context: context),
      context: context,
    );
  }

  void toggleBookmark({
    required int index,
    required String postId,
    required BuildContext context,
  }) {
    if (bookmarks.contains(index)) {
      bookmarks.remove(index);
      AppUtils.showToast(msg: 'Unsaved');
    } else {
      bookmarks.add(index);
      bookmarkPost(postId: postId, context: context);
      AppUtils.showToast(msg: 'Saved');
    }
    notifyListeners();
  }

  bool isBookmarked(int index) => bookmarks.contains(index);

  Future<void> bookmarkPost({
    required String postId,
    required BuildContext context,
  }) async {
    await ApiCall.post(
      url: Uri.parse('${APIs.baseUrl}api/v1/Post/addBookmark'),
      body: {'postid': postId},
      onSucces: (p0) {
        Logger().f(p0.body);
        notifyListeners();
      },
      onTokenExpired: () => bookmarkPost(postId: postId, context: context),
      context: context,
    );
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
          log("Comment added: ${p0.body}");
          getComment(context: context, postId: postId); // Fetch new comments
        },
        onTokenExpired: () {
          addComment(postId: postId, comment: comment, context: context);
        },
        context: context,
      );
    }
  }

  GetCommentsModel? getComments;
  bool isCommentLoading = false;
  void getComment({required BuildContext context, required String postId}) {
    isCommentLoading = true;
    notifyListeners();
    log("Controller postID $postId");

    var url = Uri.parse('${APIs.baseUrl}api/v1/Post/comments?postid=$postId');
    ApiCall.get(
      url: url,
      onSucces: (p0) {
        getComments = getCommentsModelFromJson(p0.body);
        isCommentLoading = false;
        notifyListeners();
        log(p0.body);
      },
      onTokenExpired: () {
        getComment(context: context, postId: postId);
      },
      context: context,
    );
    isCommentLoading = false;
    notifyListeners();
  }


  void singlePostLike({required bool isLiked,required String postId,required BuildContext context}){
if (isLiked) {
  unLikePost(postId: postId, context: context);
  Provider.of<GetSinglepostController>(context).getSinglePost(context: context, postId: postId);
} else {
  likePost(postId: postId, context: context);
  Provider.of<GetSinglepostController>(context).getSinglePost(context: context, postId: postId);

}
  }
}

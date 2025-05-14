import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/API_controller.dart/get_singlepost_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/dialogs/unfollowdialog.dart';
import 'package:stuedic_app/model/get_comment_model.dart';
import 'package:stuedic_app/model/getbookamark_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';

class PostInteractionController extends ChangeNotifier {
  Set<int> followers = {};
  GetBookamark? getBookamark;
  bool isLiked = false;
  int countLike = 0;

  // void toggleLike({
  //   required bool isLiked,
  //   required String postId,
  //   required BuildContext context,
  // }) async {
  //   if (isLiked) {
  //     await unLikePost(postId: postId, context: context);
  //   } else {
  //     await likePost(postId: postId, context: context);
  //   }
  //   notifyListeners();
  // }

// //like logic from pranav
  void likebool({
    required bool likebool,
    required int likeCount,
    required String postId,
    required BuildContext context,
  }) async {
    if (likebool) {
      isLiked = false;
      countLike--;
      await unLikePost(postId: postId, context: context);
    } else {
      isLiked = true;
      countLike++;
      await likePost(postId: postId, context: context);
    }
    notifyListeners();
  }

  Future<void> likePost({
    required String postId,
    required BuildContext context,
  }) async {
    await ApiMethods.get(
      url: Uri.parse('${ApiUrls.baseUrl}api/v1/Post/likePost?postid=$postId'),
      onSucces: (p0) {
        Logger().f(p0);
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
    await ApiMethods.get(
      url: Uri.parse('${ApiUrls.baseUrl}api/v1/Post/unlikePost?postid=$postId'),
      onSucces: (p0) {
        // Logger().f(p0.body);
        notifyListeners();
      },
      onTokenExpired: () => unLikePost(postId: postId, context: context),
      context: context,
    );
  }

  // void toggleFollow({
  //   required int index,
  //   required BuildContext context,
  //   required String userId,
  // }) {
  //   if (followers.contains(index)) {
  //     unFollowUserDialog(
  //       context: context,
  //       index: index,
  //       OnUnfollow: () {
  //         unfollowUser(userId: userId, context: context);
  //         followers.remove(index);
  //         notifyListeners();
  //         Navigator.pop(context);
  //       },
  //     );
  //   } else {
  //     followers.add(index);
  //     followUser(userId: userId, context: context);
  //     notifyListeners();
  //   }
  // }

  Future<void> bookmarkPost({
    required String postId,
    required BuildContext context,
  }) async {
    await ApiMethods.post(
      url: ApiUrls.addBookmark,
      body: {'postid': postId},
      onSucces: (p0) {
        Logger().f(p0.body);
        context.read<HomefeedController>().getAllPost(context: context);
        AppUtils.showToast(toastMessage: 'Post Saved');
        notifyListeners();
      },
      onTokenExpired: () => bookmarkPost(postId: postId, context: context),
      context: context,
    );
  }

  Future<void> deleteBookmark({
    required String postId,
    required BuildContext context,
  }) async {
    await ApiMethods.post(
      url: ApiUrls.deleteBookmark,
      body: {'postid': postId},
      onSucces: (p0) {
        Logger().f(p0.body);
        context.read<HomefeedController>().getAllPost(context: context);
        AppUtils.showToast(toastMessage: 'Post UnSaved');

        notifyListeners();
      },
      onTokenExpired: () => deleteBookmark(postId: postId, context: context),
      context: context,
    );
  }

  Future<void> getBookmark({
    required BuildContext context,
  }) async {
    await ApiMethods.get(
      url: ApiUrls.getBookmark,
      onSucces: (p0) {
        // Logger().f(p0.body);
        // log(p0.body);
        getBookamark = getBookamarkFromJson(p0);
        notifyListeners();
      },
      onTokenExpired: () => getBookmark(context: context),
      context: context,
    );
  }

  void toggleBookmark({
    required bool isBookmarked,
    required String postId,
    required BuildContext context,
  }) {
    if (isBookmarked) {
      deleteBookmark(postId: postId, context: context);
    } else {
      bookmarkPost(postId: postId, context: context);
    }
    notifyListeners();
  }

  //comment
  Future<void> addComment(
      {required String postId,
      required String comment,
      required BuildContext context}) async {
    Map body = {
      "content": comment,
    };
    var url =
        Uri.parse('${ApiUrls.baseUrl}api/v1/Post/addcomment?postid=$postId');
    if (comment.isNotEmpty) {
      await ApiMethods.post(
        url: url,
        body: body,
        onSucces: (p0) async {
          log("Comment added: ${p0.body}");
          // await getComment(
          //     context: context, postId: postId); // Fetch new comments
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
  Future<void> getComment(
      {required BuildContext context, required String postId}) async {
    isCommentLoading = true;
    notifyListeners();
    log("Controller postID $postId");

    var url =
        Uri.parse('${ApiUrls.baseUrl}api/v1/Post/comments?postid=$postId');
    await ApiMethods.get(
      url: url,
      onSucces: (p0) {
        getComments = getCommentsModelFromJson(p0);
        isCommentLoading = false;
        notifyListeners();
        // log(p0.body);
      },
      onTokenExpired: () {
        getComment(context: context, postId: postId);

        isCommentLoading = false;
        notifyListeners();
      },
      context: context,
    );
    isCommentLoading = false;
    notifyListeners();
  }

  void singlePostLike(
      {required bool isLiked,
      required String postId,
      required BuildContext context}) {
    if (isLiked) {
      unLikePost(postId: postId, context: context);
      Provider.of<GetSinglepostController>(context)
          .getSinglePost(context: context, postId: postId);
    } else {
      likePost(postId: postId, context: context);
      Provider.of<GetSinglepostController>(context)
          .getSinglePost(context: context, postId: postId);
    }
  }
}

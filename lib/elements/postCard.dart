import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/controller/post_interaction_controller.dart';
import 'package:stuedic_app/sheets/commentBottomSheet.dart';
import 'package:stuedic_app/sheets/postBottomSheet.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/like_styles.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {super.key,
      required this.profileUrl,
      required this.imageUrl,
      required this.caption,
      required this.name,
      required this.index,
      required this.isFollowed,
      required this.isLiked,
      required this.postId,
      required this.userId});
  final String profileUrl;
  final String imageUrl;
  final String caption;
  final String name;
  final int index;
  final bool isFollowed;
  final bool isLiked;
  final String postId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();
    final proRead = context.read<AppContoller>();
    final proWatch = context.watch<AppContoller>();
    final proWatchApi = context.watch<CrudOperationController>();
    final proReadApi = context.read<CrudOperationController>();
    final proReadInteraction = context.read<PostInteractionController>();
  

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AppUtils.getProfile(url: profileUrl),
                radius: 24,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '1 min ago',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      proReadInteraction.toggleFollow(
                          index: index, context: context, userId: userId);
                    },
                    child: Container(
                      height: 28,
                      width: proRead.isFollowing(index) ? 61 : 69,
                      decoration: BoxDecoration(
                          color: proRead.isFollowing(index)
                              ? ColorConstants.greyColor
                              : null,
                          gradient: proRead.isFollowing(index)
                              ? null
                              : ColorConstants.primaryGradientHorizontal,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                        child: Text(
                          proReadInteraction.isFollowed(index)
                              ? 'Unfollow'
                              : 'Follow',
                          style: StringStyle.smallText(isBold: true),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      postBottomSheet(
                          context: context, imageUrl: imageUrl, username: name);
                    },
                    icon: Icon(Icons.more_vert, color: Colors.black),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          GestureDetector(
            onDoubleTap: () {
              proRead.toggleLikeVisible();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: Stack(
                  children: [
                    Image.network(
                      height: 290,
                      width: double.infinity,
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Visibility(
                          visible: proWatch.isLikeVisible,
                          child: Column(
                            children: [
                              Lottie.asset(LottieAnimations.like),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(caption, style: TextStyle(fontSize: 16)),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Consumer<PostInteractionController>(
                  builder: (context, postInteraction, child) {
                    return GestureDetector(onTap: () {
                      postInteraction.toggleLike(
                          isLiked: isLiked,
                          index: index,
                          postId: postId,
                          context: context);
                    }, child: Builder(
                      builder: (context) {
                        if (isLiked || proReadInteraction.isPostLiked(index)) {
                          return LikeAnimation();
                        } else if (proReadInteraction.isPostLiked(index) ==
                                false &&
                            isLiked) {
                          return UnlikeIcon();
                        } else {
                          return UnlikeIcon();
                        }
                      },
                    ));
                  },
                ),
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      '349',
                      style: StringStyle.smallText(isBold: true),
                    ),
                    Text(
                      'Likes',
                      style: StringStyle.smallText(),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    log('post id: $postId');

                    commentBottomSheet(
                        context: context,
                        postId: postId,
                        commentController: commentController);
                    proReadInteraction.getComment(
                        postId: postId, context: context);
                  },
                  child: Row(
                    spacing: 5,
                    children: [
                      Icon(HugeIcons.strokeRoundedMessageMultiple01,
                          color: Colors.black),
                      Text(
                        proReadInteraction.getComments?.comments?.length
                                .toString() ??
                            'No',
                        style: StringStyle.smallText(isBold: true),
                      ),
                      Text(
                        'Comments',
                        style: StringStyle.smallText(),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    shareBottomSheet(context);
                  },
                  icon:
                      Icon(HugeIcons.strokeRoundedShare05, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {
                    proReadInteraction.toggleBookmark(
                        context: context, index: index, postId: postId);
                  },
                  icon: Icon(
                      proReadInteraction.isBookMarked(index)
                          ? CupertinoIcons.bookmark_fill
                          : CupertinoIcons.bookmark,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

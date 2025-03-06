import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/controller/post_interaction_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/commentBottomSheet.dart';
import 'package:stuedic_app/sheets/postBottomSheet.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/view/screens/user_profile_screen.dart';

class PostCard extends StatefulWidget {
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
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<int> scaleAnimation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 90),
        lowerBound: 1,
        upperBound: 1.5);
    scaleAnimation = Tween(begin: 20, end: 25).animate(animationController);
  }

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
              GestureDetector(
                onTap: () {
                  AppRoutes.push(
                      context, UserProfileScreen(userId: widget.userId));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AppUtils.getProfile(url: widget.profileUrl),
                      radius: 24,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
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
                  ],
                ),
              ),
              Spacer(),
                    IconButton(
                    onPressed: () {
                      postBottomSheet(
                          context: context,
                          imageUrl: widget.imageUrl,
                          username: widget.name);
                    },
                    icon: Icon(Icons.more_vert, color: Colors.black),
                  )
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
                      widget.imageUrl,
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
          Text(widget.caption, style: TextStyle(fontSize: 16)),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Consumer<PostInteractionController>(
                  builder: (context, postInteraction, child) {
                    return GestureDetector(
                      onTap: () {
                        postInteraction.toggleLike(
                          index: widget.index,
                          postId: widget.postId,
                          context: context,
                        );

                        animationController.forward().then((_) {
                          animationController.reverse();
                        });
                      },
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: animationController
                                .value, // Fixed missing scale value
                            child: Icon(
                              postInteraction.isPostLiked(widget.index)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: postInteraction.isPostLiked(widget.index)
                                  ? Colors.red
                                  : Colors.black,
                              size: 25, // Increased size for better visibility
                            ),
                          );
                        },
                      ),
                    );
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
                    log('post id: ${widget.postId}');

                    commentBottomSheet(
                        context: context,
                        postId: widget.postId,
                        commentController: commentController);
                    proReadInteraction.getComment(
                        postId: widget.postId, context: context);
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
                Consumer<PostInteractionController>(
                  builder: (context, postInteraction, child) {
                    bool isBookmarked =
                        postInteraction.isBookmarked(widget.index);
                    return IconButton(
                      icon: Icon(
                        isBookmarked
                            ? CupertinoIcons.bookmark_fill
                            : CupertinoIcons.bookmark,
                        color: ColorConstants.secondaryColor,
                      ),
                      onPressed: () {
                        postInteraction.toggleBookmark(
                          index: widget.index,
                          postId: widget.postId,
                          context: context,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

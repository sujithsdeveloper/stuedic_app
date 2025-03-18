import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/players/network_video_player.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/commentBottomSheet.dart';
import 'package:stuedic_app/sheets/postBottomSheet.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/user_profile_screen.dart';

class PostCard extends StatefulWidget {
  const PostCard(
      {super.key,
      required this.profileUrl,
      required this.mediaUrl,
      required this.caption,
      required this.name,
      required this.index,
      required this.isLiked,
      required this.postId,
      required this.userId,
      required this.postType,
      required this.likeCount});
  final String profileUrl;
  final String mediaUrl;
  final String caption;
  final String name;
  final int index;
  final bool isLiked;
  final String postId;
  final String likeCount;
  final String userId;
  final String postType;

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

    if (widget.isLiked) {
      context.read<PostInteractionController>().addLike(widget.index, context);
    }
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
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
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
                  onPressed: () async {
                    bool isRightUser = await AppUtils.checkUserIdForCurrentUser(
                        IDtoCheck: widget.userId);

                    postBottomSheet(
                        postId: widget.postId,
                        isRightUser: isRightUser,
                        context: context,
                        imageUrl: widget.mediaUrl,
                        username: widget.name);
                  },
                  icon: Icon(Icons.more_vert, color: Colors.black),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onDoubleTap: () {
              proRead.toggleLikeVisible();
            },
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(10),
              child: Center(child: Builder(
                builder: (context) {
                  if (widget.postType == StringConstants.pic) {
                    return Stack(
                      children: [
                        Image.network(
                          height: 450,
                          width: double.infinity,
                          widget.mediaUrl,
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
                                children: [Lottie.asset(LottieAnimations.like)],
                              )),
                        )
                      ],
                    );
                  }
                  if (widget.postType == StringConstants.reel) {
                    return NetworkVideoPlayer(
                      url: widget.mediaUrl,
                      inistatePlay: false,
                    );
                  } else {
                    return Container(
                      height: 50,
                      width: 50,
                      color: Colors.grey,
                      child: Center(
                        child: Text('Invalid media type'),
                      ),
                    );
                  }
                },
              )),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(widget.caption, style: TextStyle(fontSize: 16)),
          ),
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

                        // if (widget.isLiked &&
                        //     proReadInteraction.isPostLiked(widget.index) ==
                        //         false) {
                        //   proReadInteraction.removeLike(widget.index, context);
                        // }
                        if (widget.isLiked) {
                          proReadInteraction.notifyListeners();
                        }
            

                        animationController.forward().then(
                          (_) {
                            animationController.reverse();
                          },
                        );
                        Future.delayed(Duration(microseconds: 700)).then(
                          (value) {
                            context
                                .read<HomefeedController>()
                                .getAllPost(context: context);
                          },
                        );
                      },
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: animationController
                                .value, // Fixed missing scale value
                            child: Icon(
                              postInteraction.isPostLiked(widget.index) ||
                                      widget.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color:
                                  postInteraction.isPostLiked(widget.index) ||
                                          widget.isLiked
                                      ? Colors.red
                                      : null,
                              size: 25,
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
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.likeCount,
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

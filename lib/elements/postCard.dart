import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/players/network_video_player.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/commentBottomSheet.dart';
import 'package:stuedic_app/sheets/postBottomSheet.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      required this.likeCount,
      required this.time,
      required this.commentCount,
      required this.isBookmarked});
  final String profileUrl;
  final String mediaUrl;
  final String caption;
  final String name;
  final int index;
  final bool isLiked;
  // final bool isCollege;
  final String postId;
  final String likeCount;
  final String commentCount;
  final String userId;
  final String postType;
  final String time;
  final bool isBookmarked;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 90),
      lowerBound: 1,
      upperBound: 1.5,
    );
  }

  @override
  bool get wantKeepAlive => true; // Retain widget state

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure state retention
    final commentController = TextEditingController();
    // final proRead = context.read<AppContoller>();
    // final proWatch = context.watch<AppContoller>();
    // final proWatchApi = context.watch<CrudOperationController>();
    // final proReadApi = context.read<CrudOperationController>();
    final proReadInteraction = context.read<PostInteractionController>();

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Padding(
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
                          context, UserProfile(userId: widget.userId));
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
                            Row(
                              spacing: 20,
                              children: [
                                Text(
                                  '${widget.time} ago',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Icon(
                                  Icons.language,
                                  color: Colors.grey,
                                  size: 20,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () async {
                      bool isRightUser =
                          await AppUtils.checkUserIdForCurrentUser(
                              IDtoCheck: widget.userId);

                      postBottomSheet(
                          isSaved: widget.isBookmarked,
                          postId: widget.postId,
                          isRightUser: isRightUser,
                          context: context,
                          imageUrl: widget.mediaUrl,
                          username: widget.name);
                    },
                    icon: Icon(Icons.more_horiz),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onDoubleTap: () {
                // proRead.toggleLikeVisible();
              },
              child: ClipRRect(
                child: Center(
                  child: Builder(
                    builder: (context) {
                      if (widget.postType == StringConstants.pic) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: widget.mediaUrl,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 400,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  useOldImageOnUrlChange:
                                      true, // Prevent reloading
                                  cacheKey: widget.mediaUrl, // Ensure caching
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      if (widget.postType == StringConstants.reel) {
                        return ChangeNotifierProvider(
                          create: (_) => VideoTypeController(),
                          child: NetworkVideoPlayer(
                            url: widget.mediaUrl,
                            inistatePlay: false,
                          ),
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
                  ),
                ),
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
                            isLiked: widget.isLiked,
                            postId: widget.postId,
                            context: context,
                          );

                          animationController.forward().then(
                            (_) {
                              animationController.reverse();
                            },
                          );
                          Future.delayed(Duration(milliseconds: 50)).then(
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
                              scale: animationController.value,
                              child: Icon(
                                widget.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                color: widget.isLiked ? Colors.red : null,
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
                    onTap: () async {
                      log('post id: ${widget.postId}');

                      await proReadInteraction.getComment(
                          context: context, postId: widget.postId);
                      final comments = proReadInteraction
                              .getComments?.comments?.reversed
                              .toList() ??
                          [];
                      commentBottomSheet(
                          postID: widget.postId,
                          comments: comments,
                          context: context,
                          commentController: commentController);
                    },
                    child: Row(
                      spacing: 5,
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedMessageMultiple01,
                        ),
                        Text(
                          widget.commentCount ?? 'No',
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
                    icon: Icon(
                      HugeIcons.strokeRoundedShare05,
                    ),
                  ),
                  Consumer<PostInteractionController>(
                    builder: (context, postInteraction, child) {
                      return IconButton(
                        icon: Icon(
                          widget.isBookmarked
                              ? CupertinoIcons.bookmark_fill
                              : CupertinoIcons.bookmark,
                        ),
                        onPressed: () {
                          proReadInteraction.toggleBookmark(
                              isBookmarked: widget.isBookmarked,
                              postId: widget.postId,
                              context: context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

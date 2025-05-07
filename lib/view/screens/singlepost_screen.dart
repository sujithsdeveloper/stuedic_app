import 'dart:developer';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stuedic_app/controller/API_controller.dart/get_singlepost_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/players/network_video_player.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/postBottomSheet.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/functions/shimmer/shimmers_items.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

class SinglepostScreen extends StatefulWidget {
  const SinglepostScreen(
      {super.key,
      required this.postID,
      required this.userID,
      this.isCurrentUser = false});
  final String postID;
  final String userID;
  final bool isCurrentUser;
  @override
  State<SinglepostScreen> createState() => _SinglepostScreenState();
}

class _SinglepostScreenState extends State<SinglepostScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  final commentController = TextEditingController();
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 1,
      upperBound: 1.5,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<GetSinglepostController>();
      await provider.getSinglePost(context: context, postId: widget.postID);
      await context
          .read<ProfileController>()
          .getUserByUserID(userId: widget.userID, context: context);
      await context
          .read<PostInteractionController>()
          .getComment(context: context, postId: widget.postID);
      final url = provider.singlePostModel?.response?.postContentUrl;
      log(url.toString());
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<GetSinglepostController>();
    final proWatchUser = context.watch<ProfileController>();
    final post = proWatch.singlePostModel?.response;
    final user = proWatchUser.userProfile?.response;
    final proWatchInteraction = context.watch<PostInteractionController>();
    final proReadInteraction = context.read<PostInteractionController>();
    final comments =
        proWatchInteraction.getComments?.comments?.reversed.toList();
    final prowatch = context.watch<VideoTypeController>();

    return WillPopScope(
      onWillPop: () async {
        proWatchInteraction.getComments = null;
        // if (prowatch.networkVideoController!.value.isPlaying) {
        //   prowatch.networkVideoController!.pause();
        //   return true;
        // }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 9),
                child: GestureDetector(
                  onTap: () {
                    if (widget.isCurrentUser) {
                      Navigator.pop(context);
                    } else {
                      AppRoutes.push(
                          context, UserProfile(userId: widget.userID));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AppUtils.getProfile(
                              url: user?.profilePicUrl ?? ''),
                          radius: 24,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.userName ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              spacing: 20,
                              children: [
                                Text(
                                  post?.timeAgo ?? "",
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
                        Spacer(),
                        IconButton(
                          onPressed: () async {
                            bool isRightUser =
                                await AppUtils.checkUserIdForCurrentUser(
                                    IDtoCheck: widget.userID);

                            postBottomSheet(
                                isSaved: post?.isBookmarked ?? false,
                                postId: widget.postID,
                                isRightUser: isRightUser,
                                context: context,
                                imageUrl: post?.postContentUrl ?? '',
                                username: user?.userName ?? "");
                          },
                          icon: Icon(Icons.more_vert),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: 450,
                  width: double.infinity,
                  child: proWatch.isLoading
                      ? ShimmersItems.postShimmer()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  if (post!.postType == StringConstants.reel) {
                                    return NetworkVideoPlayer(
                                        url: post.postContentUrl ?? '');
                                  } else {
                                    return Image.network(
                                      post.postContentUrl ?? '',
                                      width: constraints.maxWidth,
                                      fit: BoxFit.fitWidth,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Shimmer.fromColors(
                                            child: Container(
                                              height: 400,
                                              width: double.infinity,
                                              color: Colors.white,
                                            ),
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              )),
                        )),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Consumer<PostInteractionController>(
                      builder: (context, postInteraction, child) {
                        return GestureDetector(
                          onTap: () {
                            postInteraction.toggleLike(
                              isLiked: post?.isLiked ?? false,
                              postId: widget.postID,
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
                                    .read<GetSinglepostController>()
                                    .getSinglePost(
                                        context: context,
                                        postId: widget.postID);
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
                                  post?.isLiked ?? false
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: post?.isLiked ?? false
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
                    SizedBox(width: 5),
                    Text(post?.likescount.toString() ?? '0',
                        style: StringStyle.smallText(isBold: true)),
                    Text(' Likes', style: StringStyle.smallText()),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(HugeIcons.strokeRoundedMessageMultiple01,
                              color: Colors.black),
                          SizedBox(width: 5),
                          Text(post?.commentsCount.toString() ?? 'No',
                              style: StringStyle.smallText(isBold: true)),
                          Text('Comments', style: StringStyle.smallText()),
                        ],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        shareBottomSheet(context);
                      },
                      icon: Icon(HugeIcons.strokeRoundedShare05,
                          color: Colors.black),
                    ),
                    Consumer<PostInteractionController>(
                      builder: (context, postInteraction, child) {
                        return IconButton(
                          icon: Icon(
                            post?.isBookmarked ?? false
                                ? CupertinoIcons.bookmark_fill
                                : CupertinoIcons.bookmark,
                          ),
                          onPressed: () {
                            proReadInteraction.toggleBookmark(
                                isBookmarked: post?.isBookmarked ?? false,
                                postId: post?.postId ?? '',
                                context: context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: comments?.length ?? 0,
                  itemBuilder: (context, index) {
                    final data = comments?[index];
                    final time = AppUtils.timeAgo(
                        data?.createdAt ?? DateTime.now().toString());

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          AppRoutes.push(context,
                              UserProfile(userId: data?.userId ?? 'Unknown'));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: AppUtils.getProfile(
                                url: data?.profilePicUrl ?? '',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data?.username ?? 'Unknown',
                                    style: StringStyle.normalTextBold(),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    data?.content ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "$time ago",
                                        style: StringStyle.greyText(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            commentController.text += emoji.emoji;
                          },
                          config: Config(),
                        );
                      },
                      icon: Icon(CupertinoIcons.smiley),
                    ),
                    hintText: 'Write a comment...',
                    filled: true,
                    fillColor: const Color(0xffF6F8F9),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GradientCircleAvathar(
                onTap: () {
                  if (commentController.text.isNotEmpty) {
                    proReadInteraction
                        .addComment(
                            postId: widget.postID,
                            comment: commentController.text,
                            context: context)
                        .then(
                      (value) {
                        commentController.clear();
                      },
                    );
                  }
                },
                radius: 30,
                child: const Icon(
                  CupertinoIcons.paperplane_fill,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

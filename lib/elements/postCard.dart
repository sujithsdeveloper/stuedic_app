import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/like_bloc/post_like_bloc.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/like_bloc/post_like_event.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/players/network_video_player.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/commentBottomSheet.dart';
import 'package:stuedic_app/sheets/postBottomSheet.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/like_styles.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stuedic_app/widgets/caption_widget.dart';

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
      required this.isBookmarked,
      required this.sharableLink});
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
  final String sharableLink;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  TransformationController transformationController =
      TransformationController(); // Initialize the controller
  bool postLlike = false;
  int postCount = 0;

  @override
  void initState() {
    super.initState();
    final interaction = context.read<PostInteractionController>();
    // interaction.isLiked = widget.isLiked;
    // interaction.countLike = int.parse(widget.likeCount);
    postLlike = widget.isLiked;
    postCount = int.parse(widget.likeCount);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; // Retain widget state

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure state retention
    final commentController = TextEditingController();

    final proReadInteraction = context.read<PostInteractionController>();

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
///////////////////Pots header////////////////////////////Post header/////////////////////////////////////////////////////////
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
                              AppUtils.getUserNameById(widget.name),
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
/////////////////Post media////////////////////////////Post media/////////////////////////////////////////////////////////
            GestureDetector(
              onDoubleTap: () async {
                // proRead.toggleLikeVisible();
                await animationController.forward();
                await animationController.reverse();
                final interaction = context.read<PostInteractionController>();

                BlocProvider.of<PostLikeBloc>(context).add(
                    PostLikeEvent(postId: widget.postId, context: context));

                // interaction.likebool(
                //   likebool: interaction.isLiked ?? widget.isLiked,
                //   likeCount:
                //       interaction.countLike ?? int.parse(widget.likeCount),
                //   postId: widget.postId,
                //   context: context,
                // );

                context.read<HomefeedController>().getAllPost(context: context);
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
                              ZoomableImageView(mediaUrl: widget.mediaUrl)
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
                        return ErrorPost();
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CaptionWidget(
                caption: widget.caption,
              ),
            ),
            SizedBox(height: 12),
            ///////////////Post Bottom bar///////////////////////////Post bottom bar/////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  PostLikeStyles(
                    spaceing: 5,
                    postId: widget.postId,
                    likeCount: widget.likeCount,
                    isLiked: widget.isLiked,
                    callBackFunction: () {
                      // final interaction =
                      //     context.read<PostInteractionController>();

                      BlocProvider.of<PostLikeBloc>(context).add(PostLikeEvent(
                          postId: widget.postId, context: context));

                      // interaction.likebool(
                      //   likebool: interaction.isLiked,
                      //   likeCount: interaction.countLike,
                      //   postId: widget.postId,
                      //   context: context,
                      // );
                      // context
                      //     .read<HomefeedController>()
                      //     .getAllPost(context: context);
                    },
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Likes',
                    style: StringStyle.smallText(),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      log('post id: ${widget.postId}');
                      // final userId=await AppUtils.getUserId();

                      // Open the bottom sheet immediately; comments will be fetched inside the sheet
                      commentBottomSheet(
                          postID: widget.postId,
                          context: context,
                          // userID: userId,
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
                    onPressed: () async {
                      // shareBottomSheet(context);
                      // Fix: Use Share.share instead of SharePlus.instance.share
                      await Share.share(widget.sharableLink);
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

class ErrorPost extends StatelessWidget {
  const ErrorPost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 30,
        ),
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 50,
        ),
        const SizedBox(height: 16),
        Text(
          'Oops!',
          style: StringStyle.normalTextBold(size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          'Unable to display media',
          style: StringStyle.normalText(size: 20),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'The media file could not be loaded because it\'s not a supported format on this device.',
            textAlign: TextAlign.center,
            style: StringStyle.normalText(size: 16).copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Supported types: Image (JPG, PNG), Video (MP4,m3u8)',
          style: StringStyle.normalText(size: 14).copyWith(
            color: Colors.grey[500],
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

//////////////Zoomable Image View///////////////////////Zoomable Image View/////////////////////////////////////////////////////////

class ZoomableImageView extends StatefulWidget {
  final String mediaUrl;
  const ZoomableImageView({super.key, required this.mediaUrl});

  @override
  State<ZoomableImageView> createState() => _ZoomableImageViewState();
}

class _ZoomableImageViewState extends State<ZoomableImageView> {
  late TransformationController transformationController;

  @override
  void initState() {
    super.initState();
    transformationController = TransformationController();
  }

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: InteractiveViewer(
        transformationController: transformationController,
        onInteractionEnd: (details) {
          // Animate back to identity (original) scale
          transformationController.value = Matrix4.identity();
          setState(() {});
        },
        child: CachedNetworkImage(
          imageUrl: widget.mediaUrl,
          placeholder: (context, url) => Shimmer.fromColors(
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
          errorWidget: (context, url, error) => const Icon(Icons.error),
          useOldImageOnUrlChange: true,
          cacheKey: widget.mediaUrl,
        ),
      ),
    );
  }
}

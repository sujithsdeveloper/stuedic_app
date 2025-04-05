import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/shorts_controller.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/players/network_video_player.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/commentBottomSheet.dart';
import 'package:stuedic_app/sheets/postBottomSheet.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/user_profile_screen.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<int> scaleAnimation;
  final commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 90),
        lowerBound: 1,
        upperBound: 1.5);
    context.read<ShortsController>().getReels(context: context);
    context.read<VideoTypeController>().onLongPressEnd();
    context.read<VideoTypeController>().notifyListeners();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final proWatch = context.watch<ShortsController>();
    final proRead = context.read<ShortsController>();
    final reels = proWatch.getShortsModel?.response;
    final proReadInteraction = context.read<PostInteractionController>();

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reels?.length ?? 0,
        onPageChanged: (value) {
          Provider.of<VideoTypeController>(context, listen: false)
              .controller
              .play();
        },
        itemBuilder: (context, index) {
          final reel = reels?[index];

          return Column(
            children: [
              Stack(
                children: [
                  NetworkVideoPlayer(
                    // isGestureControll: true,
                    inistatePlay: true,
                    url: reel?.postContentUrl.toString() ?? '',
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    right: 10,
                    child: ListTile(
                      leading: GestureDetector(
                          onTap: () {
                            AppRoutes.push(context,
                                UserProfileScreen(userId: reel?.userId ?? ''));
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                AppUtils.getProfile(url: reel?.profilePicUrl),
                          )),
                      title: Text(
                        reel?.username ?? 'unknown user',
                        style: StringStyle.normalTextBold(
                          size: 20,
                        ),
                      ),
                      subtitle: Text(
                        reel?.userId ?? '',
                        style: StringStyle.normalText(size: 10),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (reel?.isFollowed ?? false) {
                                context
                                    .read<PostInteractionController>()
                                    .unfollowUser(
                                        userId: reel?.userId ?? '',
                                        context: context);
                                context
                                    .read<ShortsController>()
                                    .getReels(context: context);
                              } else {
                                context
                                    .read<PostInteractionController>()
                                    .followUser(
                                        userId: reel?.userId ?? '',
                                        context: context);
                                context
                                    .read<ShortsController>()
                                    .getReels(context: context);
                              }
                            },
                            child: Container(
                              height: 28,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                    reel?.isFollowed ?? false
                                        ? 'unfollow'
                                        : 'Follow',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              bool isRightUser =
                                  await AppUtils.checkUserIdForCurrentUser(
                                      IDtoCheck: reel?.userId ?? '');
                              postBottomSheet(
                                  context: context,
                                  imageUrl: '',
                                  postId: reel?.postId ?? ' ',
                                  isRightUser: isRightUser,
                                  username: reel?.username ?? '');
                            },
                            icon: const Icon(Icons.more_horiz,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Text(
                      reel?.postDescription ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: StringStyle.normalText(size: 12),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Visibility(
                    visible: proWatch.isBuffering || !proWatch.isInitialised,
                    child: LinearProgressIndicator(
                      color: ColorConstants.primaryColor2,
                      backgroundColor: ColorConstants.greyColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5),
                    child: Row(
                      children: [
                        Consumer<PostInteractionController>(
                          builder: (context, postInteraction, child) {
                            return GestureDetector(
                              onTap: () {
                                postInteraction.toggleLike(
                                  isLiked: reel?.isLiked ?? false,
                                  postId: reel?.postId ?? '',
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
                                    scale: animationController
                                        .value, // Fixed missing scale value
                                    child: Icon(
                                      reel?.isLiked ?? false
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: reel?.isLiked ?? false
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
                              reel?.likescount.toString() ?? '0',
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
                            // log('post id: ${widget.postId}');

                            await proReadInteraction.getComment(
                                context: context, postId: reel?.postId ?? '');
                            final comments = proReadInteraction
                                    .getComments?.comments?.reversed
                                    .toList() ??
                                [];
                            commentBottomSheet(
                                postID: reel?.postId ?? '',
                                comments: comments,
                                context: context,
                                commentController: commentController);
                            // proReadInteraction.getComment(
                            //     postId: widget.postId, context: context);
                          },
                          child: Row(
                            spacing: 5,
                            children: [
                              Icon(
                                HugeIcons.strokeRoundedMessageMultiple01,
                              ),
                              Text(
                                reel?.commentsCount.toString() ?? 'No',
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
                                CupertinoIcons.bookmark,
                              ),
                              onPressed: () {
                                // log('isbookmarked: ${widget.isBookmarked}');
                                // proReadInteraction.toggleBookmark(
                                //     isBookmarked: widget.isBookmarked,
                                //     postId: widget.postId,
                                //     context: context);
                                errorSnackbar(
                                    label: StringConstants.wrong,
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
            ],
          );
        },
      ),
    );
  }
}

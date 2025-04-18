import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/shorts_controller.dart';
import 'package:stuedic_app/sheets/commentBottomSheet.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/model/get_shorts_model.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';

class ShortsBottomBar extends StatelessWidget {
  const ShortsBottomBar(
      {super.key,
      this.reel,
      required this.animationController,
      required this.commentController});
  final Response? reel;
  final AnimationController animationController;
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<ShortsController>();

    final proReadInteraction = context.read<PostInteractionController>();
    return Column(
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
                            color: reel?.isLiked ?? false ? Colors.red : null,
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
                          label: StringConstants.wrong, context: context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

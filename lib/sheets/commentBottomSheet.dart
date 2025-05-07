import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/model/get_comment_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/functions/shimmer/comment_shimmer.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';
import 'dart:math';

dynamic commentBottomSheet({
  required BuildContext context,
  required TextEditingController commentController,
  required String postID,
  // required String userID,
}) {
  final proReadInteraction = context.read<PostInteractionController>();
  final proWatchInteraction =
      Provider.of<PostInteractionController>(context, listen: false);
  proReadInteraction.getComment(context: context, postId: postID);

  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        // Listen for keyboard open and expand the sheet
        final viewInsets = MediaQuery.of(context).viewInsets;
        if (viewInsets.bottom > 0) {
          // Keyboard is open
          Future.microtask(() {
            // Animate only if not already expanded
            if (sheetController.size < 0.99) {
              sheetController.animateTo(
                1.0,
                duration: Duration(milliseconds: 250),
                curve: Curves.ease,
              );
            }
          });
        }

        // List<Comment> comments =
        //     proWatchInteraction.getComments?.comments?.reversed.toList() ?? [];

        return DraggableScrollableSheet(
          controller: sheetController,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(HugeIcons.strokeRoundedMessageMultiple01),
                        const SizedBox(width: 5),
                        Consumer<PostInteractionController>(
                          builder: (context, postInteraction, _) {
                            final comments = postInteraction
                                    .getComments?.comments?.reversed
                                    .toList() ??
                                [];
                            return Text(
                              '${postInteraction.isCommentLoading ? '...' : comments.length}',
                              style: StringStyle.smallText(isBold: true),
                            );
                          },
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Comments',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'latoRegular',
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Consumer<PostInteractionController>(
                        builder: (context, postInteraction, _) {
                          final comments = postInteraction
                                  .getComments?.comments?.reversed
                                  .toList() ??
                              [];
                          if (postInteraction.isCommentLoading) {
                            return CommentShimmerList();
                          }
                          if (comments.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No Commments',
                                    style: StringStyle.normalTextBold(size: 20),
                                  )
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final data = comments[index];
                              final time = AppUtils.timeAgo(
                                  data?.createdAt ?? DateTime.now().toString());

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        AppRoutes.push(
                                            context,
                                            UserProfile(
                                                userId: data.userId ?? ''));
                                      },
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundImage: AppUtils.getProfile(
                                          url: data.profilePicUrl ?? '',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              AppRoutes.push(
                                                  context,
                                                  UserProfile(
                                                      userId:
                                                          data.userId ?? ''));
                                            },
                                            child: Text(
                                              data.username ?? 'Unknown',
                                              style:
                                                  StringStyle.normalTextBold(),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            data.content ?? '',
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
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 16),
                      ],
                    ),
                    BottomCommentAddFeild(
                      proReadInteraction: proReadInteraction,
                      commentController: commentController,
                      postID: postID,
                      comments: proReadInteraction
                              .getComments?.comments?.reversed
                              .toList() ??
                          [],
                      setState: (fn) {
                        // fetchComments();
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

class BottomCommentAddFeild extends StatelessWidget {
  const BottomCommentAddFeild({
    super.key,
    required this.proReadInteraction,
    required this.commentController,
    required this.postID,
    required this.comments,
    required this.setState,
  });

  final PostInteractionController proReadInteraction;
  final TextEditingController commentController;
  final String postID;
  final List<Comment> comments;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              // autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(CupertinoIcons.smiley),
                hintText: 'Write a comment...',
                filled: true,
                fillColor: const Color(0xffF6F8F9),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GradientCircleAvathar(
            onTap: () async {
              if (commentController.text.isNotEmpty) {
                final text = commentController.text;

                // Optimistically add the comment to the provider's list
                final userID =
                    await AppUtils.getCurrentUserDetails(isUserId: true);
                final userName =
                    await AppUtils.getCurrentUserDetails(isUserName: true);
                final profilePicUrl =
                    await AppUtils.getCurrentUserDetails(isProfilePicurl: true);
                Comment newComment = Comment(
                  content: text,
                  createdAt: DateTime.now().toString(),
                  userId: userID,
                  profilePicUrl: profilePicUrl,
                  username: userName,
                );

                setState(() {
                  // Insert at the start of the provider's list if available
                  if (proReadInteraction.getComments?.comments != null) {
                    proReadInteraction.getComments!.comments!
                        .insert(0, newComment);
                  }
                });

                await proReadInteraction
                    .addComment(
                  postId: postID,
                  comment: text,
                  context: context,
                )
                    .then(
                  (value) {
                    commentController.clear();
                  },
                );

                // Optionally, refresh the comments from server after posting
                // await proReadInteraction.getComment(context: context, postId: postID);

                context.read<HomefeedController>().getAllPost(context: context);
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
    );
  }
}

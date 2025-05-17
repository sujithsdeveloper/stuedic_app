import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/functions/shimmer/comment_shimmer.dart';
import 'package:stuedic_app/widgets/comments/bottom_textfield.dart';
import 'package:stuedic_app/widgets/comments/comment_tile.dart';

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

                              return CommentTile(data: data, time: time);
                            },
                          );
                        },
                      ),
                    ),
                    BottomCommentAddFeild(
                      proReadInteraction: proReadInteraction,
                      commentController: commentController,
                      postID: postID,
                      comments: proReadInteraction
                              .getComments?.comments?.reversed
                              .toList() ??
                          [],
                      setState: setState,
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/model/get_comment_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

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
                    proReadInteraction.getComments!.comments!.add(newComment);
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
                    setState(
                        () {}); // <-- Add this to trigger UI update after clearing
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

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
import 'package:stuedic_app/view/screens/user_profile_screen.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

dynamic commentBottomSheet(
    {required BuildContext context,
    required TextEditingController commentController,
    required String postID,
    required List<Comment> comments}) {
  final proReadInteraction = context.read<PostInteractionController>();
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
            builder: (context, setState) => DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 0.4,
              maxChildSize: 1,
              builder: (context, scrollController) {
                // log('postID $postId');
                return SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
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
                            const Icon(
                                HugeIcons.strokeRoundedMessageMultiple01),
                            const SizedBox(width: 5),
                            Text(
                              '${comments.length}',
                              style: StringStyle.smallText(isBold: true),
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
                        Expanded(child: Builder(
                          builder: (context) {
                            if (comments.isEmpty) {
                              return Center(
                                child: Column(
                                  spacing: 20,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // SvgPicture.asset(
                                    //     height: 160, SVGConstants.comments),
                                    Text(
                                      'No Commments',
                                      style:
                                          StringStyle.normalTextBold(size: 20),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    final data = comments[index];
                                    final time = AppUtils.timeAgo(
                                        data?.createdAt ??
                                            DateTime.now().toString());

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              AppRoutes.push(
                                                  context,
                                                  UserProfileScreen(
                                                      userId:
                                                          data.userId ?? ''));
                                            },
                                            child: CircleAvatar(
                                              radius: 18,
                                              backgroundImage:
                                                  AppUtils.getProfile(
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
                                                        UserProfileScreen(
                                                            userId:
                                                                data.userId ??
                                                                    ''));
                                                  },
                                                  child: Text(
                                                    data.username ?? 'Unknown',
                                                    style: StringStyle
                                                        .normalTextBold(),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  data.content ?? '',
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "$time ago",
                                                      style: StringStyle
                                                          .greyText(),
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
                                ),
                              );
                            }
                          },
                        )),
                        Column(
                          children: [
                            const SizedBox(height: 16),
                          ],
                        ),
                        BottomCommentAddFeild(
                          proReadInteraction: proReadInteraction,
                          commentController: commentController,
                          postID: postID,
                          comments: comments,
                          setState: setState,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ));
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
              autofocus: true,
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
                await proReadInteraction.addComment(
                  postId: postID,
                  comment: commentController.text,
                  context: context,
                );
                commentController.clear();
                // Fetch updated comments and update the UI
                proReadInteraction
                    .getComment(context: context, postId: postID)
                    .then((_) {
                  setState(() {
                    comments.clear();
                    comments.addAll(proReadInteraction
                            .getComments?.comments?.reversed
                            .toList() ??
                        []);
                    context
                        .read<HomefeedController>()
                        .getAllPost(context: context);
                  });
                });
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

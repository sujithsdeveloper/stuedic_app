import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/model/get_comment_model.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

dynamic commentBottomSheet({
  required BuildContext context,
  required String postId,
  required TextEditingController commentController,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => CommentUI(
      postId: postId,
    ),
  );
}

class CommentUI extends StatefulWidget {
  const CommentUI({super.key, required this.postId});
  final String postId;

  @override
  State<CommentUI> createState() => _CommentUIState();
}

class _CommentUIState extends State<CommentUI> {
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<PostInteractionController>(context, listen: false)
        .getComment(context: context, postId: widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final proWatchInteraction =
        Provider.of<PostInteractionController>(context, listen: false);
    final commentData =
        proWatchInteraction.getComments?.comments?.reversed.toList();
    final proReadInteraction = context.read<PostInteractionController>();
    return StatefulBuilder(
      builder: (context, setState) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          // log('postID $postId');
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
                      Text(
                        '${commentData?.length ?? 0}',
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
                      if (proWatchInteraction.isCommentLoading) {
                        return loadingIndicator();
                      }
                      if (proWatchInteraction.getComments?.comments?.isEmpty ??
                          true) {
                        return Center(
                          child: Column(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  height: 160, SVGConstants.comments),
                              Text(
                                'No Commments',
                                style: StringStyle.normalTextBold(size: 20),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: commentData?.length ?? 0,
                            itemBuilder: (context, index) {
                              final data = commentData?[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                data?.createdAt ?? '',
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
                          ),
                        );
                      }
                    },
                  )),
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(CupertinoIcons.smiley),
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
                          onTap: () async {
                            proReadInteraction.addComment(
                                postId: widget.postId,
                                comment: commentController.text,
                                context: context);

                            commentController.clear();

                            proReadInteraction.getComment(
                                context: context, postId: widget.postId);
                          },
                          radius: 30,
                          child: const Icon(
                            CupertinoIcons.paperplane_fill,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

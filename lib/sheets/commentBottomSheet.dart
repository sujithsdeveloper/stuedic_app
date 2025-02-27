import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/post_interaction_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

dynamic commentBottomSheet(
    {required BuildContext context,
    required String postId,
    required TextEditingController commentController}) {
  final proWatchInteraction =
      Provider.of<PostInteractionController>(context, listen: false);
  final commentData =
      proWatchInteraction.getComments?.comments?.reversed.toList();

  final proReadInteraction = context.read<PostInteractionController>();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        builder: (context, scrollController) => SafeArea(
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
                      '760',
                      style: StringStyle.smallText(isBold: true),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Comments',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: 'latoRegular'),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_horiz))
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: commentData?.length ?? 0,
                    itemBuilder: (context, index) {
                      final data = commentData?[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                                radius: 18,
                                backgroundImage: AppUtils.getProfile(
                                    url: data?.profilePicUrl ?? null)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data?.username ?? '',
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
                                    spacing: 12,
                                    children: [
                                      Text(data?.createdAt ?? '',
                                          style: StringStyle.greyText()),
                                      // Text('Replay',
                                      //     style:
                                      //         StringStyle.greyText(isBold: true)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      HugeIcons.strokeRoundedThumbsUp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16), // Spacing before input field
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom +
                          16), // Prevents keyboard overlap
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.smiley),
                            hintText: 'Write a comment...',
                            filled: true,
                            fillColor: Color(0xffF6F8F9),
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
                          proReadInteraction.addComment(
                              postId: postId,
                              comment: commentController.text,
                              context: context);
                          proReadInteraction.getComment(
                              context: context, postId: postId);
                          commentController.clear();
                        },
                        radius: 30,
                        child: const Icon(CupertinoIcons.paperplane_fill,
                            size: 20),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stuedic_app/controller/API_controller.dart/get_singlepost_controller.dart';
import 'package:stuedic_app/sheets/postBottomSheet.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

class SinglepostScreen extends StatefulWidget {
  const SinglepostScreen({super.key, required this.postID});
  final String postID;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use listen: false here
      final provider = Provider.of<GetSinglepostController>(context);
      provider.getSinglePost(context: context, postId: widget.postID);

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
    final proWatch =
        Provider.of<GetSinglepostController>(context, listen: false);
    final post = proWatch.singlePostModel?.response;
    return Scaffold(
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
              onTap: () {},
              radius: 30,
              child: const Icon(
                CupertinoIcons.paperplane_fill,
                size: 20,
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 9),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      AppUtils.getProfile(url: post?.profilePicUrl ?? ''),
                ),
                SizedBox(width: 9),
                Text('Username', style: StringStyle.normalTextBold()),
                Spacer(),
                IconButton(
                  onPressed: () {
                    postBottomSheet(
                      context: context,
                      imageUrl: '',
                      postId: '',
                      isRightUser: true,
                      username: 'Username',
                    );
                  },
                  icon: Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          SizedBox(
              height: 450,
              width: double.infinity,
              child: proWatch.isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(8), // Optional: Smooth edges
                        child: Container(
                          width: double.infinity,
                          height: 450,
                          color: Colors.grey[
                              300], // Fallback color for better visibility
                        ),
                      ),
                    )
                  : Image.network(
                      fit: BoxFit.cover, post?.postContentUrl ?? '')),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    animationController.forward().then((_) {
                      animationController.reverse();
                    });
                  },
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: animationController.value,
                        child: Icon(
                          Icons.favorite_border_outlined,
                          size: 25,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 5),
                Text('0', style: StringStyle.smallText(isBold: true)),
                Text('Likes', style: StringStyle.smallText()),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(HugeIcons.strokeRoundedMessageMultiple01,
                          color: Colors.black),
                      SizedBox(width: 5),
                      Text('No', style: StringStyle.smallText(isBold: true)),
                      Text('Comments', style: StringStyle.smallText()),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    shareBottomSheet(context);
                  },
                  icon:
                      Icon(HugeIcons.strokeRoundedShare05, color: Colors.black),
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.bookmark,
                    color: ColorConstants.secondaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/elements/postCard.dart';
import 'package:stuedic_app/styles/string_styles.dart';

class ProfilepostScreen extends StatefulWidget {
  const ProfilepostScreen({super.key, required this.postId});
  final String postId;

  @override
  State<ProfilepostScreen> createState() => _ProfilepostScreenState();
}

class _ProfilepostScreenState extends State<ProfilepostScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // final pic = await context
        //     .watch<ProfileController>()
        //     .userProfile
        //     ?.response
        //     ?.profilePicUrl
        //     .toString();
        // log('profile ${pic.toString()}');
        context
            .read<ProfileController>()
            .getSinglePost(context: context, postId: widget.postId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final singlePostData =
        context.watch<ProfileController>().singlePostModel?.response;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Posts',
          style: StringStyle.appBarText(context: context),
        ),
      ),
      // body: PostCard(
      //     likeCount: singlePostData?.likescount.toString() ?? '0',
      //     postType: singlePostData?.postType ?? '',
      //     profileUrl: singlePostData?.profilePicUrl ?? '',
      //     mediaUrl: singlePostData?.postContentUrl ?? '',
      //     caption: singlePostData?.postDescription ?? '',
      //     name: singlePostData?.username ?? 'No Name',
      //     index: 0,
      //     isLiked: singlePostData?.isLiked ?? false,
      //     postId: singlePostData?.postId ?? '',
      //     userId: singlePostData?.userId ?? ''),
    );
  }
}

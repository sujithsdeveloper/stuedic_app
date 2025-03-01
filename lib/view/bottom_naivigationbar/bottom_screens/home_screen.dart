import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/elements/postCard.dart';
import 'package:stuedic_app/elements/story_section.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/refreshTocken.dart';
import 'package:stuedic_app/view/screens/chat_list_screen.dart';
import 'package:stuedic_app/view/screens/notification_default_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String currentUserId;
  @override
  void initState() {
    super.initState();
    context.read<HomefeedController>().getAllPost(context: context);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final currentUserId = await AppUtils.getUserId();
        log('Current userid= $currentUserId');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final proReadHomeFeed = context.read<HomefeedController>();
    final proWatchHomeFeed = context.watch<HomefeedController>();
    final items = proWatchHomeFeed.homeFeed?.response?.reversed.toList();
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   refreshAccessToken(context: context);
      // }),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomefeedController>().getAllPost(context: context);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
                floating: true,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  StringConstants.appName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'latoRegular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      HugeIcons.strokeRoundedNotification01,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      AppRoutes.push(context, NotificationDefaultScreen());
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      HugeIcons.strokeRoundedMessage01,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      AppRoutes.push(context, ChatListScreen());
                    },
                  ),
                ]),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: StorySection(),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = items?[index];
                return PostCard(
                  isLiked: item?.isLiked ?? false,
                  isFollowed: false,
                  index: index,
                  userId: item?.userId ?? '',
                  imageUrl: item?.postContentUrl ?? '',
                  name: item?.username ?? '',
                  profileUrl: item?.profilePicUrl ?? '',
                  caption: item?.postDescription ?? '',
                  postId: item?.postId ?? '',
                );
              }, childCount: items?.length ?? 0),
            ),
          ],
        ),
      ),
    );
  }
}

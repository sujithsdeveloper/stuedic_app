import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/elements/postCard.dart';
import 'package:stuedic_app/elements/story_section.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/chat/chat_list_screen.dart';
import 'package:stuedic_app/view/screens/notification_screen.dart';
import 'package:stuedic_app/widgets/gradient_container.dart';
import 'package:stuedic_app/widgets/refresh_indicator_widget.dart';

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
    final like = context
        .read<HomefeedController>()
        .homeFeed
        ?.response?[0]
        .isLiked
        .toString();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final currentUserId = await AppUtils.getUserId();
        log('Current userid= $currentUserId');
        log('isLiked $like');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final proReadHomeFeed = context.read<HomefeedController>();
    final proWatchHomeFeed = context.watch<HomefeedController>();
    final items = proWatchHomeFeed.homeFeed?.response?.reversed.toList();
    return Scaffold(
      body: customRefreshIndicator(
        onRefresh: () async {
          context.read<HomefeedController>().getAllPost(context: context);
        },
        child: CustomScrollView(
          cacheExtent: context.screenHeight,
          slivers: [
            SliverAppBar(
                floating: true,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Row(
                  spacing: 9,
                  children: [
                    GradientContainer(
                      height: 23,
                      width: 9,
                      verticalGradient: true,
                    ),
                    Text(StringConstants.appName,
                        style: StringStyle.appBarText()),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      HugeIcons.strokeRoundedNotification01,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      AppRoutes.push(context, NotificationScreen());
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      HugeIcons.strokeRoundedMessage01,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // AppRoutes.push(context, ChatListScreen());
                      
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
              delegate: SliverChildBuilderDelegate(addAutomaticKeepAlives: true,
                  (context, index) {
                final item = items?[index];
                final time=AppUtils.timeAgo(item?.createdAt??DateTime.now());

                return PostCard(
                  likeCount: item?.likescount.toString() ?? '0',
                  postType: item?.postType ?? '',
                  isLiked: item?.isLiked ?? false,
                  index: index,
                  time: time,
                  userId: item?.userId ?? '',
                  mediaUrl: item?.postContentUrl ?? '',
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

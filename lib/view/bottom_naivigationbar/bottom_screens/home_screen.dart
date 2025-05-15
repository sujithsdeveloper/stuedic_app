import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_Api_call_bloc/bloc/homefeed_data_fetch_bloc.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_Api_call_bloc/bloc/homefeed_data_fetch_state.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/like_bloc/post_like_bloc.dart';
import 'package:stuedic_app/controller/like_controller/like_controller.dart';
import 'package:stuedic_app/elements/postCard.dart';
import 'package:stuedic_app/elements/story_section.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/model/home_feed_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/app_info.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/functions/shimmer/homeShimmer.dart';
import 'package:stuedic_app/view/screens/notification_screen.dart';
import 'package:stuedic_app/widgets/gradient_container.dart';
import 'package:stuedic_app/widgets/refresh_indicator_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.controller, this.isfirstTime = false});
  final PageController controller;
  final bool isfirstTime;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late String currentUserId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.isfirstTime) {
        BlocProvider.of<HomefeedDataFetchBloc>(context)
            .add(HomefeedDataFetchEvent());
        // final proReadHomeFeed = context.read<HomefeedController>();
        // proReadHomeFeed.changeShimmer();
      }
      onpaginationscroll();
      final currentUserId = await AppUtils.getUserId();
      log('Current userid= $currentUserId');
    });
  }

  @override
  bool get wantKeepAlive => true;
  final scrollController = ScrollController();

  onpaginationscroll() {
    scrollController.addListener(() {
      final bloc = BlocProvider.of<HomefeedDataFetchBloc>(context);

      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          bloc.isMore) {
        bloc.add(HomefeedDataFetchEvent());
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final proWatchHomeFeed = context.watch<HomefeedController>();

    // bool islike = false;
    // String likeCount = '0';

    return BlocBuilder<HomefeedDataFetchBloc, HomefeedDataFetchState>(
      builder: (context, state) {
        if (state is HomefeedDataFetchLoading) {
          return HomeShimmer();
        }

        if (state is HomefeedDataFetchSussess ||
            state is HomefeedDataFetchMore) {
          // final items = proWatchHomeFeed.homeFeed?.response?.reversed.toList();
          // final items = state.response?.reversed.toList();
          var blocHomefeed = BlocProvider.of<HomefeedDataFetchBloc>(context);
          final items = blocHomefeed.resBlocList.toList();
          return customRefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              final bloc = BlocProvider.of<HomefeedDataFetchBloc>(context);
              bloc.isMore = true;
              bloc.pageCount = 1;
              bloc.resBlocList.clear();
              return bloc.add(HomefeedDataFetchEvent());
            },
            child: Scaffold(
              body: CustomScrollView(
                controller: scrollController,
                cacheExtent: context.screenHeight,
                slivers: [
                  //
                  SliverAppBar(
                    floating: true,
                    elevation: 0,
                    title: Row(
                      children: [
                        GradientContainer(
                            height: 23, width: 9, verticalGradient: true),
                        const SizedBox(width: 9),
                        GestureDetector(
                          onTap: () {
                            scrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                          },
                          child: Text(
                            AppInfo.appName,
                            style: TextStyle(
                              fontFamily: 'Calistoga',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(HugeIcons.strokeRoundedNotification01),
                        onPressed: () {
                          AppRoutes.push(context, NotificationScreen());
                        },
                      ),
                      IconButton(
                        icon: Icon(HugeIcons.strokeRoundedMessage01),
                        onPressed: () {
                          widget.controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 110,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: StorySection(),
                      ),
                    ),
                  ),
                  items == null || items.isEmpty
                      ? SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height / 2.3,
                            child: Text(
                              'No data found add post now',
                              style: StringStyle.normalTextBold(size: 18),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // final item = items[index];

                              if (index == items.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }

                              final item = items[index];
                              final time =
                                  AppUtils.timeAgo(item.createdAt.toString());
                              // islike = item.isLiked ?? false;
                              // likeCount = item.likescount.toString();
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                child: BlocProvider<PostLikeBloc>(
                                  create: (context) => PostLikeBloc(
                                      initialCount: item.likescount ?? -5,
                                      initialbool: item.isLiked ?? false),
                                  child: PostCard(
                                    sharableLink: item.shareableLink ?? '',
                                    isBookmarked: item.isBookmarked ?? false,
                                    likeCount:
                                        item.likescount.toString() ?? '0',
                                    postType: item.postType ?? '',
                                    isLiked: item.isLiked ?? false,
                                    commentCount:
                                        item.commentsCount.toString() ?? '0',
                                    index: index,
                                    time: time,
                                    userId: item.userId ?? '',
                                    mediaUrl: item.postContentUrl ?? '',
                                    name: item.username ?? '',
                                    profileUrl: item.profilePicUrl ?? '',
                                    caption: item.postDescription ?? '',
                                    postId: item.postId ?? '',
                                  ),
                                ),
                              );
                            },
                            childCount:
                                items.length + (blocHomefeed.isMore ? 1 : 0),
                          ),
                        ),
                ],
              ),
            ),
          );
        }

        if (state is HomefeedDataFetchError) {
          return Text(state.errorMessage);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

//-----------
// class HomeScreen extends StatefulWidget {
//   const HomeScreen(
//       {super.key, required this.controller, this.isfirstTime = false});
//   final PageController controller;
//   final bool isfirstTime;

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with AutomaticKeepAliveClientMixin {
//   late String currentUserId;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       if (widget.isfirstTime) {
//         final proReadHomeFeed = context.read<HomefeedController>();
//         proReadHomeFeed.changeShimmer();
//       }
//       final currentUserId = await AppUtils.getUserId();
//       log('Current userid= $currentUserId');
//     });
//   }

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     final proWatchHomeFeed = context.watch<HomefeedController>();

//     final items = proWatchHomeFeed.homeFeed?.response?.reversed.toList();
//     final scrollController = ScrollController();
//     // bool islike = false;
//     // String likeCount = '0';

//     return Scaffold(
//       body: customRefreshIndicator(
//         onRefresh: () async {
//           context.read<HomefeedController>().getAllPost(context: context);
//         },
//         child: proWatchHomeFeed.showShimmer
//             ? HomeShimmer()
//             : CustomScrollView(
//                 controller: scrollController,
//                 cacheExtent: context.screenHeight,
//                 slivers: [
//                   //
//                   SliverAppBar(
//                     floating: true,
//                     elevation: 0,
//                     title: Row(
//                       children: [
//                         GradientContainer(
//                             height: 23, width: 9, verticalGradient: true),
//                         const SizedBox(width: 9),
//                         GestureDetector(
//                           onTap: () {
//                             scrollController.animateTo(0.0,
//                                 duration: Duration(milliseconds: 200),
//                                 curve: Curves.easeIn);
//                           },
//                           child: Text(
//                             StringConstants.appName,
//                             style: TextStyle(
//                               fontFamily: 'Calistoga',
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       IconButton(
//                         icon: Icon(HugeIcons.strokeRoundedNotification01),
//                         onPressed: () {
//                           AppRoutes.push(context, NotificationScreen());
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(HugeIcons.strokeRoundedMessage01),
//                         onPressed: () {
//                           widget.controller.nextPage(
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeIn,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   SliverToBoxAdapter(
//                     child: SizedBox(
//                       height: 110,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: StorySection(),
//                       ),
//                     ),
//                   ),
//                   items == null || items.isEmpty
//                       ? SliverToBoxAdapter(
//                           child: Center(
//                             child: Text(
//                               'No data found add post now',
//                               style: StringStyle.normalTextBold(size: 18),
//                             ),
//                           ),
//                         )
//                       : SliverList(
//                           delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                               final item = items[index];
//                               final time =
//                                   AppUtils.timeAgo(item.createdAt.toString());
//                               // islike = item.isLiked ?? false;
//                               // likeCount = item.likescount.toString();
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 24, vertical: 8),
//                                 child: BlocProvider<PostLikeBloc>(
//                                   create: (context) => PostLikeBloc(
//                                       initialCount: item.likescount ?? -5,
//                                       initialbool: item.isLiked ?? false),
//                                   child: PostCard(
//                                     isBookmarked: item.isBookmarked ?? false,
//                                     likeCount:
//                                         item.likescount.toString() ?? '0',
//                                     postType: item.postType ?? '',
//                                     isLiked: item.isLiked ?? false,
//                                     commentCount:
//                                         item.commentsCount.toString() ?? '0',
//                                     index: index,
//                                     time: time,
//                                     userId: item.userId ?? '',
//                                     mediaUrl: item.postContentUrl ?? '',
//                                     name: item.username ?? '',
//                                     profileUrl: item.profilePicUrl ?? '',
//                                     caption: item.postDescription ?? '',
//                                     postId: item.postId ?? '',
//                                   ),
//                                 ),
//                               );
//                             },
//                             childCount: items.length,
//                           ),
//                         ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

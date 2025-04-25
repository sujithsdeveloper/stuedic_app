import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/app/scrolling_controller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/appbars/college_appbar.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/appbars/user_appbar.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/tabs/bookmarked_grid.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/tabs/image_grid.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/tabs/video_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.userId});
  final String? userId;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileController>();
      provider.getCurrentUserData(context: context);
      provider.getCurrentUserGrid(context: context);
    });

    context
        .read<ScrollingController>()
        .controllerScroll(scrollController: scrollController);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userDataProviderWatch = context.watch<ProfileController>();
    final postInteractionProviderWatch =
        context.watch<PostInteractionController>();
    final user = userDataProviderWatch.userCurrentDetails?.response;
    final photoGrid = userDataProviderWatch
        .currentUserProfileGrid?.response?.posts?.reversed
        .toList();
    final bookmarkGrid =
        postInteractionProviderWatch.getBookamark?.response?.bookmarks;
    final gridViewScrollEnabled =
        context.watch<ScrollingController>().gridViewScrollEnabled;

    bool isCollege =
        userDataProviderWatch.userCurrentDetails?.response?.isCollege ?? false;
    bool isCurrentUser =
        userDataProviderWatch.userCurrentDetails?.response?.isCurrentUser ??
            false;

    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          isCollege
              ? CollegeProfileAppbar(
                  user: user, isCurrentUser: isCurrentUser, widget: widget)
              : UserProfileAppbar(
                  user: user, isCurrentUser: isCurrentUser, widget: widget),
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            forceElevated: false,
            toolbarHeight: 0.0,
            collapsedHeight: 0.0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                // No margin or padding here
                color: Colors.white,
                child: TabBar(
                  labelColor: ColorConstants.secondaryColor,
                  indicatorColor: ColorConstants.secondaryColor,
                  controller: _tabController,
                  onTap: (value) {
                    if (value == 0) {
                      context
                          .read<ProfileController>()
                          .getCurrentUserGrid(context: context);
                    }
                    if (value == 1) {
                      // context
                      //     .read<ProfileController>()
                      //     .getCurrentUserVideos(context: context);
                    }
                    if (value == 2) {
                      context
                          .read<PostInteractionController>()
                          .getBookmark(context: context);
                    }
                  },
                  tabs: const [
                    Tab(icon: Icon(HugeIcons.strokeRoundedLayoutGrid)),
                    Tab(icon: Icon(HugeIcons.strokeRoundedAiVideo)),
                    Tab(icon: Icon(HugeIcons.strokeRoundedAllBookmark)),
                    Tab(icon: Icon(HugeIcons.strokeRoundedShoppingBag03)),
                  ],
                ),
              ),
            ),
          )
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          ImageGrid(
              scrollController: scrollController,
              gridViewScrollEnabled: gridViewScrollEnabled,
              photoGrid: photoGrid,
              userId: user?.userId ?? ''),
          // Videos Section
          VideoGrid(
            scrollController: scrollController,
            gridViewScrollEnabled: gridViewScrollEnabled,
          ),

          // Bookmarked Items
          BookmarkedGrid(
              gridViewScrollEnabled: gridViewScrollEnabled,
              bookmarkGrid: bookmarkGrid,
              userId: user?.userId ?? ''),

          // Shopping Items
          Center(
            child: Text("Shopping items will be displayed here",
                style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    ));
  }
}

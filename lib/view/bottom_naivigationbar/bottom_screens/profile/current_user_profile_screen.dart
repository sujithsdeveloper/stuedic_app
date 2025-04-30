import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/app/scrolling_controller.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/tabs/bookmarked_grid.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/tabs/image_grid.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/tabs/video_grid.dart';
import 'package:stuedic_app/view/screens/edit_profile_screen.dart';
import 'package:stuedic_app/view/screens/notification_screen.dart';
import 'package:stuedic_app/view/screens/pdf_viewer_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/profile_action_button.dart';

class CurrentUserStudentProfileScreen extends StatefulWidget {
  const CurrentUserStudentProfileScreen({super.key, this.userId});
  final String? userId;
  @override
  State<CurrentUserStudentProfileScreen> createState() =>
      _CurrentUserStudentProfileScreenState();
}

class _CurrentUserStudentProfileScreenState
    extends State<CurrentUserStudentProfileScreen>
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

    // bool isCollege =
    //     userDataProviderWatch.userCurrentDetails?.response?.isCollege ?? false;
    // bool isCurrentUser =
    //     userDataProviderWatch.userCurrentDetails?.response?.isCurrentUser ??
    //         false;

    return Scaffold(
        body: CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          expandedHeight: context.screenHeight * 0.5,
          actions: [
            IconButton(
              onPressed: () {
                AppRoutes.push(context, NotificationScreen());
              },
              icon: Icon(HugeIcons.strokeRoundedNotification01),
            ),
            IconButton(
              onPressed: () {
                AppRoutes.push(context, SettingScreen());
              },
              icon: Icon(Icons.more_horiz),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 178,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(ImageConstants.userProfileBg),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 9, right: 9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 110),
                                  CircleAvatar(
                                    radius: 62,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: AppUtils.getProfile(
                                        url: user?.profilePicUrl,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 20,
                                children: [
                                  ProfileActionButton(
                                    iconData: CupertinoIcons.doc_text,
                                    onTap: () {
                                      AppRoutes.push(context,
                                          PdfViewerScreen(url: pdfUrl));
                                    },
                                  ),
                                  GradientButton(
                                    outline: user?.isFollowed ?? false,
                                    onTap: () {
                                      AppRoutes.push(
                                        context,
                                        EditProfileScreen(
                                          username: user?.userName ?? '',
                                          bio: 'bio',
                                          number: user?.phone ?? 'No Number',
                                          url: user?.profilePicUrl ?? '',
                                        ),
                                      );
                                    },
                                    height: 48,
                                    width: 120,
                                    isColored: !(user?.isFollowed ?? false),
                                    label: 'Edit Profile',
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.userName ?? '',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('@${user?.userId ?? ''}',
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 5),
                      Text(user?.collageName ?? '',
                          style: StringStyle.normalText()),
                      Text('Trivandrum, Kerala',
                          style: StringStyle.normalText()),
                      SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          counts(
                              count:
                                  AppUtils.formatCounts(user?.postCount ?? 0),
                              label: "Posts"),
                          counts(
                              count: AppUtils.formatCounts(
                                  user?.followingCount ?? 0),
                              label: "Following"),
                          counts(
                              count: AppUtils.formatCounts(
                                  user?.followersCount ?? 0),
                              label: "Followers"),
                          counts(
                              count: AppUtils.formatCounts(0), label: "Likes"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
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
        ),
        SliverFillRemaining(
          child: TabBarView(
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
        )
      ],
    ));
  }
}

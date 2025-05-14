import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/app/scrolling_controller.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/elements/tabbar_delegates.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/tabs_view/tabsView.dart';
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

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  //  User Profile Avatar
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      //icons settings and vertical more

                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: Image.asset(
                          ImageConstants.userProfileBg,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: -70,
                        left: 16,
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AppUtils.getProfile(
                              url: user?.profilePicUrl,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Row(
                          children: [
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
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 9), // space for avatar

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Edit profile & and pdf icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ProfileActionButton(
                              iconData: CupertinoIcons.doc_text,
                              onTap: () {
                                AppRoutes.push(
                                    context, PdfViewerScreen(url: pdfUrl));
                              },
                            ),
                            const SizedBox(width: 10),
                            GradientButton(
                              outline: user?.isFollowed ?? false,
                              onTap: () {
                                AppRoutes.push(
                                  context,
                                  EditProfileScreen(
                                    isCollege: user?.isCollege ?? false,
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
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Text(AppUtils.getUserNameById(user?.userName),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('@${user?.userId ?? ''}',
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 5),
                        Text(user?.collageName ?? '',
                            style: StringStyle.normalText()),
                        // Text('Trivandrum, Kerala',
                        //     style: StringStyle.normalText()),

                        const SizedBox(height: 20),

                        // Stats row
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
                                count: AppUtils.formatCounts(0),
                                label: "Likes"),
                          ],
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 👇 Pinned TabBar
            SliverPersistentHeader(
              pinned: true,
              delegate: TabBarDelegate(
                context: context,
                TabBar(
                  controller: _tabController,
                  labelColor: ColorConstants.secondaryColor,
                  indicatorColor: ColorConstants.secondaryColor,
                  onTap: (value) {
                    if (value == 0) {
                      context
                          .read<ProfileController>()
                          .getCurrentUserGrid(context: context);
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
          ],
          body: Padding(
            padding: EdgeInsets.only(top: kToolbarHeight * 0.5),
            child: TabBarView(
              controller: _tabController,
              children: [
                CurrentUserImageview(
                  photoGrid: photoGrid,
                ),
                CurrentUserVideoView(),
                SavedItemsView(
                  bookmarkGrid: bookmarkGrid,
                ),
                Center(
                  child: Text(
                    "This feature is not available ye",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

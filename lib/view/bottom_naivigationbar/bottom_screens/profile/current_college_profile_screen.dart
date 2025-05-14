import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/editprofile_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/elements/details_item.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/elements/tabbar_delegates.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/utils/shortcuts/app_shortcuts.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/tabs_view/tabsView.dart';
import 'package:stuedic_app/view/screens/chat/chat_screen.dart';
import 'package:stuedic_app/view/screens/club_screen.dart';
import 'package:stuedic_app/view/screens/college/college_departments.dart';
import 'package:stuedic_app/view/screens/edit_profile_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/view/screens/singlepost_screen.dart';
import 'package:stuedic_app/view/screens/user_profile/tabbar_sections/user_profile_tabbar_section.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/profile_action_button.dart';

class CurrenUserCollegeProfileScreen extends StatefulWidget {
  const CurrenUserCollegeProfileScreen({super.key, this.userId});
  final String? userId;
  @override
  State<CurrenUserCollegeProfileScreen> createState() =>
      CurrenUserCollegeProfileScreenState();
}

class CurrenUserCollegeProfileScreenState
    extends State<CurrenUserCollegeProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ProfileController>().getCurrentUserData(context: context);
      },
    );
    context.read<ProfileController>().getCurrentUserGrid(context: context);

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userDataProviderWatch = context.watch<ProfileController>();
    final user = userDataProviderWatch.userCurrentDetails?.response;
    // bool isDarkTheme = AppUtils.isDarkTheme(context);
    final photoGrid =
        userDataProviderWatch.currentUserProfileGrid?.response?.posts;
    final postInteractionProviderWatch =
        context.watch<PostInteractionController>();
    final bookmarkGrid =
        postInteractionProviderWatch.getBookamark?.response?.bookmarks;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 178,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    ImageConstants.collegeProfileBg))),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    AppUtils.getUserNameById(user?.userName),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '@${user?.userId ?? ''}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8,
                        children: [
                          GradientButton(
                            onTap: () {
                              AppRoutes.push(
                                  context,
                                  EditProfileScreen(
                                    username: user?.userName ?? '',
                                    bio: user?.bio ?? '',
                                    isCollege: user?.isCollege ?? false,
                                    url: user?.profilePicUrl ?? '',
                                    number: user?.phone ?? '',
                                  ));
                            },
                            height: 48,
                            width: 100,
                            isColored: true,
                            label: 'Edit Profile',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    counts(
                                        count: AppUtils.formatCounts(
                                            user?.collageStrength ?? 0),
                                        label: "Students"),
                                    counts(
                                        count: AppUtils.formatCounts(0),
                                        label: "Staffs"),
                                    counts(
                                        onTap: () {
                                          AppRoutes.push(
                                              context, CollegeDepartments());
                                        },
                                        count: AppUtils.formatCounts(
                                            user?.allDepartments?.length ?? 0),
                                        label: "Departments"),
                                    counts(
                                        onTap: () {
                                          AppRoutes.push(context, ClubScreen());
                                        },
                                        count: AppUtils.formatCounts(0),
                                        label: "Clubs"),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                  splashColor: Colors.transparent,
                                  dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,
                                expandedAlignment: Alignment.topLeft,
                                title: Text(
                                  'Details',
                                  style: StringStyle.normalTextBold(size: 16),
                                ),
                                children: [
                                  DetailsItem(
                                    title: 'Address',
                                    subtitle: lorum,
                                    iconData: CupertinoIcons.location,
                                  ),
                                  DetailsItem(
                                    onIconTap: () {
                                      if (user?.email != null) {
                                        EasyLauncher.email(
                                            email: user?.email ?? '');
                                      } else {
                                        AppUtils.showToast(
                                            toastMessage: 'Email not provided');
                                      }
                                    },
                                    title: 'Email',
                                    subtitle: user?.email ?? 'Not Provided',
                                    iconData: CupertinoIcons.envelope,
                                  ),
                                  DetailsItem(
                                    onIconTap: () {
                                      if (user?.phone != null) {
                                        EasyLauncher.call(
                                            number: user?.phone ?? '');
                                      } else {
                                        AppUtils.showToast(
                                            toastMessage:
                                                'Phone number not provided');
                                      }
                                    },
                                    title: 'Phone Number',
                                    subtitle: user?.phone ?? 'Not Provided',
                                    iconData: HugeIcons.strokeRoundedCall,
                                  ),
                                  DetailsItem(
                                    title: 'Affiliation',
                                    subtitle: "Dummy University",
                                    iconData: Icons.school_outlined,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 90,
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 62,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AppUtils.getProfile(
                            url: user?.profilePicUrl ?? null),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
                pinned: true,
                delegate: TabBarDelegate(
                    context: context,
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(icon: Icon(HugeIcons.strokeRoundedLayoutGrid)),
                        Tab(icon: Icon(HugeIcons.strokeRoundedAiVideo)),
                        Tab(icon: Icon(HugeIcons.strokeRoundedAllBookmark)),
                        Tab(icon: Icon(HugeIcons.strokeRoundedShoppingBag03)),
                      ],
                    )))
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            CurrentUserImageview(photoGrid: photoGrid),
            // Videos Section
            CurrentUserVideoView(),

            // Shopping Items
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Builder(
                  builder: (context) {
                    if (bookmarkGrid == null) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text('No Items')],
                        ),
                      );
                    } else {
                      return GridView.builder(
                        itemCount: bookmarkGrid?.length ?? 0,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 9 / 16,
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4),
                        itemBuilder: (context, index) {
                          final bookmarkedItem = bookmarkGrid?[index];
                          return GestureDetector(
                            onTap: () {
                              AppRoutes.push(
                                  context,
                                  SinglepostScreen(
                                      postID: bookmarkedItem?.postId ?? '',
                                      userID: user?.userId ?? ''));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffF5FFBB),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          bookmarkedItem?.postContentUrl ??
                                              ''))),
                            ),
                          );
                        },
                      );
                    }
                  },
                )),
            Center(
              child: Text("This feature is not available yet",
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/model/getbookamark_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/view/screens/chat/chat_screen.dart';
import 'package:stuedic_app/view/screens/college_user_profile_screen.dart';
import 'package:stuedic_app/view/screens/edit_profile_screen.dart';
import 'package:stuedic_app/view/screens/pdf_viewer_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/profile_action_button.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.userId});
  final String userId;
  @override
  State<UserProfileScreen> createState() => _ProfileScreenStudentState();
}

class _ProfileScreenStudentState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context
          .read<ProfileController>()
          .getUserByUserID(context: context, userId: widget.userId);
      context
          .read<ProfileController>()
          .getUseGrid(context: context, userID: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDataProviderWatch = context.watch<ProfileController>();

    final user = userDataProviderWatch.userProfile?.response;
    final photoGrid = userDataProviderWatch.userGridModel?.response?.posts;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            floating: true,
            expandedHeight: context.screenHeight / 2.2,
            actions: [
              IconButton(
                onPressed: () {
                  AppRoutes.push(
                      context, CollegeUserProfileScreen(userId: '68806004'));
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
                                  spacing: 9,
                                  children: [
                                    ProfileActionButton(
                                      iconData: CupertinoIcons.doc_text,
                                      onTap: () {
                                        AppRoutes.push(context,
                                            PdfViewerScreen(url: pdfUrl));
                                      },
                                    ),
                                    ProfileActionButton(
                                      iconData: CupertinoIcons.envelope,
                                      onTap: () {
                                        AppRoutes.push(
                                            context,
                                            ChatScreen(
                                                name: user?.userName ?? '',
                                                imageUrl:
                                                    user?.profilePicUrl ?? '',
                                                userId: user?.userId ?? ''));
                                      },
                                    ),
                                    GradientButton(
                                      outline: user?.isFollowed ?? false,
                                      onTap: () {
                                        // context
                                        //     .read<ProfileController>()
                                        //     .followUser(
                                        //         context: context,
                                        //         userId: user?.userId ?? '');
                                      },
                                      height: 48,
                                      width: 120,
                                      isColored: !(user?.isFollowed ?? false),
                                      label: 'Follow',
                                    ),
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
                                count: AppUtils.formatCounts(2000),
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
                                count: AppUtils.formatCounts(20000000),
                                label: "Likes"),
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
                color: Colors.white, // Set the background color to white
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
                    Tab(icon: Icon(HugeIcons.strokeRoundedShoppingBag03)),
                  ],
                ),
              ),
            ),
          )
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                itemCount: photoGrid?.length ?? 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 9 / 16,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF5FFBB),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                photoGrid?[index].postContentUrl ?? ''))),
                  );
                },
              ),
            ),
            // Videos Section
            Center(
              child: Text("Videos will be displayed here",
                  style: TextStyle(fontSize: 16)),
            ),

            // Shopping Items
            Center(
              child: Text("Shopping items will be displayed here",
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/delegates/tabbarDelegate.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/view/screens/edit_profile_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';


class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });
  @override
  State<UserProfileScreen> createState() => _ProfileScreenStudentState();
}

class _ProfileScreenStudentState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    context
        .read<ProfileController>()
        .getUserByUserID(context: context, userId: widget.userId);

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userDataProviderWatch = context.watch<ProfileController>();
    final user = userDataProviderWatch.userProfile?.response;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 5,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // SliverAppBar with FlexibleSpaceBar
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              // toolbarHeight: 90,
              floating: true,
              expandedHeight: 450,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(HugeIcons.strokeRoundedNotification01)),
                IconButton(
                    onPressed: () {
                      AppRoutes.push(context, SettingScreen());
                    },
                    icon: Icon(Icons.more_horiz))
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Background image
                    Stack(
                      children: [
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'https://images.pexels.com/photos/19942412/pexels-photo-19942412/free-photo-of-portrait-of-woman-in-hat-in-winter.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load'))),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 9,
                                right: 9,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 110,
                                      ),
                                      CircleAvatar(
                                          radius: 62,
                                          backgroundColor:
                                              ColorConstants.primaryColor,
                                          child: CircleAvatar(
                                              radius: 60,
                                              backgroundImage:
                                                  AppUtils.getProfile(
                                                      url:
                                                          user?.profilePicUrl ??
                                                              null))),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GradientButton(
                                          onTap: () {
                                            AppRoutes.push(
                                                context,
                                                EditProfileScreen(
                                                  name: user?.userName ?? '',
                                                  Username: user?.userId ?? '',
                                                  bio: 'Flutter developer',
                                                ));
                                          },
                                          height: 48,
                                          width: 130,
                                          isColored: true,
                                          label: 'Edit Profile')
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        user?.userName ?? '',
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
                              SizedBox(
                                height: 70,
                                width: double.infinity,
                                child: Text(
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    "Lorem Ipsum is simply printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 45,
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
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // TabBar
            SliverPersistentHeader(
              pinned: true,
              delegate: TabBarDelegate(
                TabBar(
                  labelColor: ColorConstants.secondaryColor,
                  indicatorColor: ColorConstants.secondaryColor,
                  splashFactory: NoSplash.splashFactory,
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(HugeIcons.strokeRoundedImage01)),
                    Tab(icon: Icon(HugeIcons.strokeRoundedGrid)),
                    Tab(icon: Icon(HugeIcons.strokeRoundedAiVideo)),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Grid view
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MasonryGridView.builder(
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: items.length,
                // itemCount: userDataProviderWatch
                //         .profileGridPosts?.response?.posts
                //         ?.where((post) =>
                //             post.postContentUrl != null &&
                //             post.postContentUrl!.isNotEmpty)
                //         .length ??
                //     0,
                itemBuilder: (context, index) {
                  // final validPosts = userDataProviderWatch
                  //         .profileGridPosts?.response?.posts
                  //         ?.where((post) =>
                  //             post.postContentUrl != null &&
                  //             post.postContentUrl!.isNotEmpty)
                  //         .toList() ??
                  //     [];

                  if (items.isEmpty) {
                    return const Center(
                      child: Text('No valid posts available'),
                    );
                  }

                  final data = items[index];
                  final containerHeight = (index % 3 == 0) ? 200.0 : 300.0;

                  return GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: containerHeight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(data['profileUrl']),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Tab 2: Videos
            const Center(
              child: Text('Videos Tab Content'),
            ),
            // Tab 3: Photos
            const Center(
              child: Text('Photos Tab Content'),
            ),
          ],
        ),
      ),
    );
  }
}

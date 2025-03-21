import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/profile_action_button.dart';
import 'package:stuedic_app/widgets/stuedic_point_container.dart';

class CollegeUserProfileScreen extends StatefulWidget {
  const CollegeUserProfileScreen({super.key, required this.userId});
  final String userId;
  @override
  State<CollegeUserProfileScreen> createState() =>
      _CollegeUserProfileScreenState();
}

class _CollegeUserProfileScreenState extends State<CollegeUserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context
            .read<ProfileController>()
            .getUserByUserID(context: context, userId: widget.userId);
      },
    );
    context
        .read<ProfileController>()
        .getUseGrid(context: context, userID: widget.userId);

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userDataProviderWatch = context.watch<ProfileController>();
    final user = userDataProviderWatch.userProfile?.response;
    final grids = userDataProviderWatch.userGridModel?.response?.posts;

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
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 110,
                                ),
                                CircleAvatar(
                                  radius: 62,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: AppUtils.getProfile(
                                        url: user?.profilePicUrl ?? null),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        ProfileActionButton(
                          iconData: CupertinoIcons.envelope,
                          onTap: () {},
                        ),
                        GradientButton(
                            outline: user?.isFollowed ?? false ? true : false,
                            onTap: () {},
                            height: 48,
                            width: 100,
                            isColored: user?.isFollowed ?? false ? false : true,
                            label: user?.isFollowed ?? false
                                ? 'Unfollow'
                                : 'Follow'),
                        ProfileActionButton(
                          iconData: Icons.share_outlined,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: StuedicPointContainer(
                        point: '23456780',
                      ),
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
            // SliverPersistentHeader(
            //   pinned: true,
            //   delegate: TabBarDelegate(
            //     TabBar(
            //       labelColor: ColorConstants.secondaryColor,
            //       indicatorColor: ColorConstants.secondaryColor,
            //       splashFactory: NoSplash.splashFactory,
            //       controller: _tabController,
            //       tabs: const [
            //         Tab(icon: Icon(HugeIcons.strokeRoundedImage01)),
            //         Tab(icon: Icon(HugeIcons.strokeRoundedGrid)),
            //         Tab(icon: Icon(HugeIcons.strokeRoundedAiVideo)),
            //       ],
            //     ),
            //   ),
            // ),
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
                itemCount: grids?.length ?? 0,
                itemBuilder: (context, index) {
                  if (userDataProviderWatch.userGridModel?.response == null) {
                    return const Center(
                      child: Text('No posts available'),
                    );
                  }

                  final containerHeight = (index % 3 == 0) ? 200.0 : 300.0;

                  return GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: containerHeight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                grids?[index].postContentUrl ?? ''),
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

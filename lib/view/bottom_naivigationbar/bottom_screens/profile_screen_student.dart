import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/delegates/tabbarDelegate.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/view/screens/college_user_profile_screen.dart';
import 'package:stuedic_app/view/screens/pdf_viewer_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/profile_action_button.dart';

class ProfileScreenStudent extends StatefulWidget {
  const ProfileScreenStudent({
    super.key,
  });
  @override
  State<ProfileScreenStudent> createState() => _ProfileScreenStudentState();
}

class _ProfileScreenStudentState extends State<ProfileScreenStudent>
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

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userDataProviderWatch = context.watch<ProfileController>();
    final user = userDataProviderWatch.userCurrentDetails?.response;
    final grids = userDataProviderWatch.currentUserProfileGrid?.response?.posts;

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
              expandedHeight: 410,
              actions: [
                IconButton(
                    onPressed: () {
                      AppRoutes.push(context,
                          CollegeUserProfileScreen(userId: '68806004'));
                    },
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
                                      ImageConstants.userProfileBg))),
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
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundImage: AppUtils.getProfile(
                                              url: user?.profilePicUrl ?? null),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 8,
                                    children: [
                                      ProfileActionButton(
                                        iconData: CupertinoIcons.doc_text,
                                        onTap: () {
                                          AppRoutes.push(
                                              context,
                                              PdfViewerScreen(
                                                url: pdfUrl,
                                              ));
                                        },
                                      ),
                                      GradientButton(
                                          outline: user?.isFollowed ?? false
                                              ? true
                                              : false,
                                          onTap: () {},
                                          height: 48,
                                          width: 120,
                                          isColored: user?.isFollowed ?? false
                                              ? false
                                              : true,
                                          label: 'Edit Profile'),
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
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 9,
                                    children: [
                                      Text(
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        user?.collageName ?? '',
                                        style: StringStyle.normalText(),
                                      ),
                                      Text(
                                        'Trivandrum, Kerala',
                                        style: StringStyle.normalText(),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 35,
                                    width: 77,
                                    decoration: BoxDecoration(
                                        color: ColorConstants.greyColor,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Center(
                                      child: Row(
                                        spacing: 3,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              fit: BoxFit.cover,
                                              height: 22,
                                              width: 22,
                                              ImageConstants.points),
                                          Text('500',
                                              style:
                                                  StringStyle.normalTextBold())
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 9,
                              ),
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
                itemCount: grids?.length ?? 0,
                itemBuilder: (context, index) {
                  final containerHeight = (index % 3 == 0) ? 200.0 : 300.0;

                  return Builder(
                    builder: (context) {
                      if (grids == null) {
                        log('Tab null');
                        return const Center(
                          child: Text('No posts available'),
                        );
                      } else {
                        log(grids.toString());
                        return GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: containerHeight,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      grids[index].postContentUrl ?? ''),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
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

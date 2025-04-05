import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/elements/details_item.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/view/screens/college/college_departments.dart';
import 'package:stuedic_app/view/screens/edit_profile_screen.dart';
import 'package:stuedic_app/view/screens/pdf_viewer_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/profile_action_button.dart';
import 'package:stuedic_app/widgets/stuedic_point_container.dart';

class CollegeProfileScreen extends StatefulWidget {
  const CollegeProfileScreen({super.key});

  @override
  State<CollegeProfileScreen> createState() => CollegeProfileScreenState();
}

class CollegeProfileScreenState extends State<CollegeProfileScreen>
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
    final photoGrid = userDataProviderWatch.userGridModel?.response?.posts;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // SliverAppBar with FlexibleSpaceBar
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: context.screenHeight,
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
                          iconData: CupertinoIcons.doc_text,
                          onTap: () {},
                        ),
                        GradientButton(
                            outline: user?.isFollowed ?? false ? true : false,
                            onTap: () {
                              AppRoutes.push(
                                  context,
                                  EditProfileScreen(
                                    bio: user?.bio ?? "",
                                    number: user?.phone ?? '',
                                    url: user?.profilePicUrl ?? '',
                                    username: user?.userName ?? '',
                                  ));
                            },
                            height: 48,
                            width: 100,
                            isColored: user?.isFollowed ?? false ? false : true,
                            label: 'Edit Profile'),
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
                        point: '0',
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
                                      count: AppUtils.formatCounts(0),
                                      label: "Clubs"),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Details',
                                  style: StringStyle.normalTextBold(size: 16),
                                ),
                              ),
                              DetailsItem(
                                  title: 'Address',
                                  subtitle: lorum,
                                  iconData: CupertinoIcons.location),
                              DetailsItem(
                                  title: 'Email',
                                  subtitle: user?.email ?? 'Not Provided',
                                  iconData: CupertinoIcons.envelope),
                              DetailsItem(
                                  title: 'Phone Number',
                                  subtitle: user?.phone ?? 'Not Provided',
                                  iconData: HugeIcons.strokeRoundedCall),
                              DetailsItem(
                                  title: 'Affiliation',
                                  subtitle: "Dummy University",
                                  iconData: Icons.school_outlined),
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
                  // color: isDarkTheme ? ColorConstants.darkColor : Colors.white,
                  child: TabBar(
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
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Builder(
                  builder: (context) {
                    if (photoGrid == null || photoGrid.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Capture some amazing moments with your friends',
                            style: StringStyle.normalTextBold(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                              ),
                              Text('Create your first post')
                            ],
                          )
                        ],
                      );
                    } else {
                      return GridView.builder(
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
                                        photoGrid?[index].postContentUrl ??
                                            ''))),
                          );
                        },
                      );
                    }
                  },
                )),
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

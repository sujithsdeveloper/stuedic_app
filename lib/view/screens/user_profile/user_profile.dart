import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/elements/details_item.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/view/screens/chat/chat_screen.dart';
import 'package:stuedic_app/view/screens/club_screen.dart';
import 'package:stuedic_app/view/screens/college/college_departments.dart';
import 'package:stuedic_app/view/screens/notification_screen.dart';
import 'package:stuedic_app/view/screens/pdf_viewer_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/profile_action_button.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.userId});
  final String userId;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final provider = context.read<ProfileController>();

        provider.getUserByUserID(context: context, userId: widget.userId);
        provider.getUseGrid(context: context, userID: widget.userId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userDataProviderWatch = context.watch<ProfileController>();
    final user = userDataProviderWatch.userProfile?.response;
    final photoGrid = userDataProviderWatch.userGridModel?.response?.posts;

    final isCollege = user?.isCollege ?? false;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          isCollege
              ? SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: context.screenHeight,
                  actions: [
                    // IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(HugeIcons.strokeRoundedNotification01)),
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
                              onTap: () {
                                AppRoutes.push(
                                    context,
                                    ChatScreen(
                                        name: user?.userName ??
                                            'Username not available',
                                        imageUrl: user?.profilePicUrl ?? '',
                                        userId: user!.userId.toString()));
                              },
                            ),
                            GradientButton(
                              outline: user?.isFollowed ?? false ? true : false,
                              onTap: () {
                                if (user?.isFollowed ?? false) {
                                  context
                                      .read<PostInteractionController>()
                                      .unfollowUser(
                                          context: context,
                                          userId: user?.userId ?? '');
                                  Future.delayed(Duration(milliseconds: 300))
                                      .then(
                                    (value) {
                                      context
                                          .read<ProfileController>()
                                          .getUserByUserID(
                                              context: context,
                                              userId: widget.userId);
                                    },
                                  );
                                } else {
                                  context
                                      .read<PostInteractionController>()
                                      .followUser(
                                          context: context,
                                          userId: user?.userId ?? '');
                                  Future.delayed(Duration(milliseconds: 300))
                                      .then(
                                    (value) {
                                      context
                                          .read<ProfileController>()
                                          .getUserByUserID(
                                              context: context,
                                              userId: widget.userId);
                                    },
                                  );
                                }
                              },
                              height: 48,
                              width: 100,
                              isColored:
                                  user?.isFollowed ?? false ? false : true,
                              label: user?.isFollowed ?? false
                                  ? 'Following'
                                  : 'Follow',
                            ),
                            ProfileActionButton(
                              onTap: () {
                                shareBottomSheet(context);
                              },
                              iconData: Icons.share_outlined,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: StuedicPointContainer(
                        //     point: '0',
                        //   ),
                        // ),
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
                                              user?.allDepartments?.length ??
                                                  0),
                                          label: "Departments"),
                                      counts(
                                          onTap: () {
                                            AppRoutes.push(
                                                context, ClubScreen());
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Details',
                                      style:
                                          StringStyle.normalTextBold(size: 16),
                                    ),
                                  ),
                                  DetailsItem(
                                      title: 'Address',
                                      subtitle: lorum,
                                      iconData: CupertinoIcons.location),
                                  DetailsItem(
                                      onIconTap: () {
                                        if (user?.email != null) {
                                          EasyLauncher.email(
                                              email: user?.email ?? '');
                                        } else {
                                          AppUtils.showToast(
                                            msg: 'Email not provided',
                                          );
                                        }
                                      },
                                      title: 'Email',
                                      subtitle: user?.email ?? 'Not Provided',
                                      iconData: CupertinoIcons.envelope),
                                  DetailsItem(
                                      onIconTap: () {
                                        if (user?.email != null) {
                                          EasyLauncher.call(
                                              number: user?.phone ?? '');
                                        } else {
                                          AppUtils.showToast(
                                            msg: 'Phone number not provided',
                                          );
                                        }
                                      },
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
                      color: Colors.white,
                      child: TabBar(
                        controller: tabController,
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
              : SliverAppBar(
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
                                  image:
                                      AssetImage(ImageConstants.userProfileBg),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 9, right: 9),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              backgroundImage:
                                                  AppUtils.getProfile(
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
                                                      name:
                                                          user?.userName ?? '',
                                                      imageUrl:
                                                          user?.profilePicUrl ??
                                                              '',
                                                      userId:
                                                          user?.userId ?? ''));
                                            },
                                          ),
                                          GradientButton(
                                              outline:
                                                  user?.isFollowed ?? false,
                                              onTap: () {
                                                if (user?.isFollowed ?? false) {
                                                  context
                                                      .read<
                                                          PostInteractionController>()
                                                      .unfollowUser(
                                                          userId:
                                                              user?.userId ??
                                                                  '',
                                                          context: context);
                                                } else {
                                                  context
                                                      .read<
                                                          PostInteractionController>()
                                                      .followUser(
                                                          userId:
                                                              user?.userId ??
                                                                  '',
                                                          context: context);
                                                }
                                              },
                                              height: 48,
                                              width: 120,
                                              isColored:
                                                  !(user?.isFollowed ?? false),
                                              label: user?.isFollowed ?? false
                                                  ? 'Unfollow'
                                                  : 'Follow'),
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
                        controller: tabController,
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
          controller: tabController,
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
              child: Text("saved items will be displayed here",
                  style: TextStyle(fontSize: 16)),
            ),
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

import 'dart:developer';

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/follow_btn_bloc/follow_btn_bloc.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/elements/details_item.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/elements/tabbar_delegates.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/utils/shortcuts/app_shortcuts.dart';
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
        final userDataProviderWatch =
            Provider.of<ProfileController>(context, listen: false);
        userDataProviderWatch.isFollowed =
            userDataProviderWatch.userProfile?.response?.isFollowed ?? false;

        final provider = context.read<ProfileController>();

        provider.getUserByUserID(context: context, userId: widget.userId);
        provider.getUseGrid(context: context, userID: widget.userId);
        log(' ${userDataProviderWatch.userProfile?.response?.isFollowed.toString()}',
            name: 'inite api call follow Status ');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userDataProviderWatch = context.watch<ProfileController>();
    final user = userDataProviderWatch.userProfile?.response;
    final photoGrid = userDataProviderWatch.userGridModel?.response?.posts;
    log('${user?.isFollowed.toString()}',
        name: 'passing bloc follow status inside build method');

    final isCollege = user?.isCollege ?? false;
    // final isCollege = false;
    return BlocProvider(
      create: (context) =>
          FollowBtnBloc(initialFollowStatus: user?.isFollowed ?? false),
      child: Scaffold(
        body: userDataProviderWatch.userByUserIdIsloading
            ? loadingIndicator()
            : BlocBuilder<FollowBtnBloc, FollowBtnState>(
                builder: (context, followState) {
                  return SafeArea(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        isCollege
                            ?
                            ///////////////////////College Profile//////////////////////////////////////////////////////////////////////////////////////////////
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
                                                      ImageConstants
                                                          .collegeProfileBg))),
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      user?.userName ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                        imageUrl:
                                                            user?.profilePicUrl ??
                                                                '',
                                                        userId: user!.userId
                                                            .toString()));
                                              },
                                            ),
                                            GradientButton(
                                              outline: userDataProviderWatch
                                                          .isFollowed ??
                                                      false
                                                  ? true
                                                  : false,
                                              onTap: () {
                                                BlocProvider.of<FollowBtnBloc>(
                                                        context)
                                                    .add(FollowBtnEvent(
                                                        userId: user!.userId
                                                            .toString(),
                                                        context: context));
                                              },
                                              height: 48,
                                              width: 100,
                                              isColored: followState.isFollow,
                                              label: followState.isFollow
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      counts(
                                                          count: AppUtils
                                                              .formatCounts(
                                                                  user?.collageStrength ??
                                                                      0),
                                                          label: "Students"),
                                                      counts(
                                                          count: AppUtils
                                                              .formatCounts(0),
                                                          label: "Staffs"),
                                                      counts(
                                                          onTap: () {
                                                            AppRoutes.push(
                                                                context,
                                                                CollegeDepartments());
                                                          },
                                                          count: AppUtils
                                                              .formatCounts(user
                                                                      ?.allDepartments
                                                                      ?.length ??
                                                                  0),
                                                          label: "Departments"),
                                                      counts(
                                                          onTap: () {
                                                            AppRoutes.push(
                                                                context,
                                                                ClubScreen());
                                                          },
                                                          count: AppUtils
                                                              .formatCounts(0),
                                                          label: "Clubs"),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Details',
                                                      style: StringStyle
                                                          .normalTextBold(
                                                              size: 16),
                                                    ),
                                                  ),
                                                  DetailsItem(
                                                      title: 'Address',
                                                      subtitle: lorum,
                                                      iconData: CupertinoIcons
                                                          .location),
                                                  DetailsItem(
                                                      onIconTap: () {
                                                        if (user?.email !=
                                                            null) {
                                                          EasyLauncher.email(
                                                              email:
                                                                  user?.email ??
                                                                      '');
                                                        } else {
                                                          AppUtils.showToast(
                                                            msg:
                                                                'Email not provided',
                                                          );
                                                        }
                                                      },
                                                      title: 'Email',
                                                      subtitle: user?.email ??
                                                          'Not Provided',
                                                      iconData: CupertinoIcons
                                                          .envelope),
                                                  DetailsItem(
                                                      onIconTap: () {
                                                        if (user?.email !=
                                                            null) {
                                                          EasyLauncher.call(
                                                              number:
                                                                  user?.phone ??
                                                                      '');
                                                        } else {
                                                          AppUtils.showToast(
                                                            msg:
                                                                'Phone number not provided',
                                                          );
                                                        }
                                                      },
                                                      title: 'Phone Number',
                                                      subtitle: user?.phone ??
                                                          'Not Provided',
                                                      iconData: HugeIcons
                                                          .strokeRoundedCall),
                                                  DetailsItem(
                                                      title: 'Affiliation',
                                                      subtitle:
                                                          "Dummy University",
                                                      iconData: Icons
                                                          .school_outlined),
                                                ],
                                              ),
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
                                    Positioned(
                                        top: 0,
                                        left: 0,
                                        child: AppShortcuts
                                            .getPlatformDependentPop(
                                          color: Colors.black,
                                          onPop: () {
                                            Navigator.pop(context);
                                          },
                                        ))
                                  ],
                                ),
                              )
                            :
                            ///////////////////////User Profile//////////////////////////////////////////////////////////////////////////////////////////////
                            // User Profile
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
                                              backgroundImage:
                                                  AppUtils.getProfile(
                                                url: user?.profilePicUrl,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 5,
                                          top: 40,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  AppRoutes.push(context,
                                                      NotificationScreen());
                                                },
                                                icon: Icon(HugeIcons
                                                    .strokeRoundedNotification01),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  AppRoutes.push(
                                                      context, SettingScreen());
                                                },
                                                icon: Icon(Icons.more_horiz),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: AppShortcuts
                                                .getPlatformDependentPop(
                                              color: Colors.black,
                                              onPop: () {
                                                Navigator.pop(context);
                                              },
                                            ))
                                      ],
                                    ),

                                    const SizedBox(
                                        height: 9), // space for avatar

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Edit profile & and pdf icon
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ProfileActionButton(
                                                iconData:
                                                    CupertinoIcons.doc_text,
                                                onTap: () {
                                                  AppRoutes.push(
                                                      context,
                                                      PdfViewerScreen(
                                                          url: pdfUrl));
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              GradientButton(
                                                outline:
                                                    user?.isFollowed ?? false,
                                                onTap: () {
                                                  // AppRoutes.push(
                                                  //   context,
                                                  //   EditProfileScreen(
                                                  //     username: user?.userName ?? '',
                                                  //     bio: 'bio',
                                                  //     number: user?.phone ?? 'No Number',
                                                  //     url: user?.profilePicUrl ?? '',
                                                  //   ),
                                                  // );
                                                },
                                                height: 48,
                                                width: 120,
                                                isColored: !(user?.isFollowed ??
                                                    false),
                                                label: 'Follow',
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 16),
                                          Text(user?.userName ?? '',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Text('@${user?.userId ?? ''}',
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          const SizedBox(height: 5),
                                          Text(user?.collageName ?? '',
                                              style: StringStyle.normalText()),
                                          Text('Trivandrum, Kerala',
                                              style: StringStyle.normalText()),

                                          const SizedBox(height: 20),

                                          // Stats row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              counts(
                                                  count: AppUtils.formatCounts(
                                                      user?.postCount ?? 0),
                                                  label: "Posts"),
                                              counts(
                                                  count: AppUtils.formatCounts(
                                                      user?.followingCount ??
                                                          0),
                                                  label: "Following"),
                                              counts(
                                                  count: AppUtils.formatCounts(
                                                      user?.followersCount ??
                                                          0),
                                                  label: "Followers"),
                                              counts(
                                                  count:
                                                      AppUtils.formatCounts(0),
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
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: TabBarDelegate(
                            TabBar(
                              controller: tabController,
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
                                Tab(
                                    icon: Icon(
                                        HugeIcons.strokeRoundedLayoutGrid)),
                                Tab(icon: Icon(HugeIcons.strokeRoundedAiVideo)),
                                Tab(
                                    icon: Icon(
                                        HugeIcons.strokeRoundedShoppingBag03)),
                              ],
                            ),
                          ),
                        ),
                      ],
                      body: TabBarView(
                        controller: tabController,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Builder(
                                builder: (context) {
                                  if (photoGrid == null || photoGrid.isEmpty) {
                                    return Column(
                                      spacing: 5,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Capture some amazing moments with your friends',
                                          style: StringStyle.normalTextBold(),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
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
                                                      photoGrid?[index]
                                                              .postContentUrl ??
                                                          ''))),
                                        );
                                      },
                                    );
                                  }
                                },
                              )),
                          // Videos Section
                          Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Capture some amazing moments with your friends',
                                style: StringStyle.normalTextBold(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                  ),
                                  Text('Create your first video')
                                ],
                              )
                            ],
                          ),

                          // Shopping Items

                          Center(
                            child: Text("This feature is not available yet",
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

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
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/club_screen.dart';
import 'package:stuedic_app/view/screens/college/college_departments.dart';
import 'package:stuedic_app/view/screens/edit_profile_screen.dart';
import 'package:stuedic_app/view/screens/notification_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/view/screens/singlepost_screen.dart';
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
            // SliverAppBar with FlexibleSpaceBar
          
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
              child: Text("Shopping items will be displayed here",
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

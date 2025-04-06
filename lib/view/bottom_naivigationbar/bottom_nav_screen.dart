import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/discover_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:stuedic_app/controller/story/story_picker_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/create_post_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/discover_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/home_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile_screen_student.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/shorts_screen.dart';
import 'package:stuedic_app/view/screens/chat/chat_list_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/college_profile_screen.dart';
import 'package:stuedic_app/view/screens/media/pick_media_screen.dart';
import 'package:stuedic_app/view/screens/story_asset_picker_screen.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({
    super.key,
  });

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with SingleTickerProviderStateMixin {
  bool isCollege = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final token = await AppUtils.getToken();
        log(token);

        final profileController = context.read<ProfileController>();
        final discoverController = context.read<DiscoverController>();
        final storyController = context.read<StoryController>();
        // isCollege =
        //     profileControllerWatch.userCurrentDetails?.response!.isStudent! ??
        //         false;

        profileController.getCurrentUserData(context: context);
        profileController.getCurrentUserGrid(context: context);
        discoverController.getDiscoverData(context);
        storyController.getStories(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();
    final profileControllerWatch = context.watch<ProfileController>();
    bool isCollege =
        profileControllerWatch.userCurrentDetails?.response?.isCollege ?? false;

    List<Widget> userScreens = [
      HomePage(),
      DiscoverScreen(),
      Container(),
      ShortsScreen(),
      ProfileScreenStudent()
    ];
    List<Widget> CollegeuserScreens = [
      HomePage(),
      DiscoverScreen(),
      Container(),
      ShortsScreen(),
      CollegeProfileScreen()
    ];

    return WillPopScope(
      onWillPop: () async {
        if (proWatch.currentIndex != 0) {
          proRead.chnageBottomNav(index: 0, context: context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: isCollege
            ? CollegeuserScreens[proWatch.currentIndex]
            : userScreens[proWatch.currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Transform.translate(
          offset: const Offset(0, 10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35,
            child: GradientCircleAvathar(
              onTap: () {
                AppRoutes.push(context, CreatePostScreen());
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          onTap: (value) {
            proRead.chnageBottomNav(index: value, context: context);
          },
          currentIndex: proWatch.currentIndex,
          elevation: 3,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedDiscoverSquare),
                label: "Discover"),
            BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
            BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedAiVideo), label: "Shorts"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_alt_circle), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? pagecontroller;
  @override
  void initState() {
    super.initState();
    pagecontroller = PageController(
      initialPage: 0,
    );
    setState(() {});
    context.read<HomefeedController>().getAllPost(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<AppContoller>();
    List<Widget> pages = [
      // AssetPickerPage(
      //   pageController: pagecontroller,
      // ),
      HomeScreen(controller: pagecontroller!),
      ChatListScreen(
        controller: pagecontroller!,
      )
    ];
    return PageView(
      onPageChanged: (value) {
        if (value == 0) {
          context.watch<StoryPickerController>().selectedAssets = [];
          context.read<StoryPickerController>().notifyListeners();
        }
      },
      physics:
          proWatch.currentIndex == 0 ? null : NeverScrollableScrollPhysics(),
      controller: pagecontroller,
      restorationId: 'home_page_view',
      children: pages,
    );
  }
}

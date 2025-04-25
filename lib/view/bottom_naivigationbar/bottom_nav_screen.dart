import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/discover_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/controller/home_page_controller.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/create_post_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/discover_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/home_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/current_user_profile_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/shorts/shorts_screen.dart';
import 'package:stuedic_app/view/screens/chat/chat_list_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/college_profile_screen.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key, required this.isfirstTime});
  final bool isfirstTime;
  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    AppUtils.checkConnectivity(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final token = await AppUtils.getToken();
      log(token);

      final appContoller = context.read<AppContoller>();
      final profileController = context.read<ProfileController>();
      final discoverController = context.read<DiscoverController>();
      final storyController = context.read<StoryController>();
      final feedController = context.read<HomefeedController>();
      // appContoller.chnageBottomNav(index: 0, context: context);
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          profileController.getCurrentUserData(context: context);
          profileController.getCurrentUserGrid(context: context);
          discoverController.getDiscoverData(context);
          feedController.getAllPost(context: context);
          storyController.getStories(context);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();
    final profileControllerWatch = context.watch<ProfileController>();

    bool isCollege =
        profileControllerWatch.userCurrentDetails?.response?.isCollege ?? false;
    String userId =
        profileControllerWatch.userCurrentDetails?.response?.userId ?? '';

    List<Widget> userScreens = [
      HomePage(
        isfirstTime: widget.isfirstTime,
      ),
      DiscoverScreen(),
      Container(),
      ShortsScreen(),
      ProfileScreen(
        userId: userId,
      )
    ];
    List<Widget> CollegeuserScreens = [
      HomePage(isfirstTime: widget.isfirstTime),
      DiscoverScreen(),
      Container(),
      ShortsScreen(),
      CollegeProfileScreen()
    ];

    return WillPopScope(
      onWillPop: () async {
        if (proWatch.currentIndex != 0) {
          proRead.changeBottomNav(index: 0, context: context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: proWatch.currentIndex,
          children: isCollege ? CollegeuserScreens : userScreens,
        ),
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
            proRead.changeBottomNav(index: value, context: context);
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
  const HomePage({super.key, required this.isfirstTime});
  final bool isfirstTime;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<HomePageController>().HomePageControl();
      },
    ); // setState(() {});
    // context.read<HomefeedController>().getAllPost(context: context);
  }

  @override
  Widget build(BuildContext context) {
    // final proWatch = context.watch<AppContoller>();
    final proWatchHomepage = context.watch<HomePageController>();
    List<Widget> pages = [
      // AssetPickerPage(
      //   pageController: pagecontroller,
      // ),
      HomeScreen(
        controller: proWatchHomepage.pageController!,
        isfirstTime: widget.isfirstTime,
      ),
      ChatListScreen(
        controller: proWatchHomepage.pageController!,
      )
    ];
    return PageView(
      // onPageChanged: (value) {
      //   if (value == 0) {
      //     // context.watch<StoryPickerController>().selectedAssets = [];
      //     // context.read<StoryPickerController>().notifyListeners();
      //   }
      // },
      controller: proWatchHomepage.pageController!,
      restorationId: 'home_page_view',
      children: pages,
    );
  }
}

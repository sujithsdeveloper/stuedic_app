import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/discover_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/create_post_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/discover_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/home_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/current_college_profile_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/current_user_profile_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/shorts/shorts_screen.dart';
import 'package:stuedic_app/view/screens/chat/chat_list_screen.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key, required this.showShimmer});
  final bool showShimmer;
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

      final profileController = context.read<ProfileController>();
      final discoverController = context.read<DiscoverController>();
      final storyController = context.read<StoryController>();
      final feedController = context.read<HomefeedController>();

      profileController.getCurrentUserData(context: context);
      profileController.getCurrentUserGrid(context: context);
      discoverController.getDiscoverData(context);
      feedController.getAllPost(context: context);
      storyController.getStories(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userScreens = [
      HomePage(isfirstTime: widget.showShimmer),
      DiscoverScreen(),
      Container(),
      ShortsScreen(),
      CurrentUserStudentProfileScreen()
    ];
    final CollegeuserScreens = [
      HomePage(isfirstTime: widget.showShimmer),
      DiscoverScreen(),
      Container(),
      ShortsScreen(),
      CurrenUserCollegeProfileScreen()
    ];
    final proWatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();
    final profileControllerWatch = context.watch<ProfileController>();

    bool isCollege =
        profileControllerWatch.userCurrentDetails?.response?.isCollege ?? false;

    return WillPopScope(
      onWillPop: () async {
        if (proWatch.currentIndex != 0) {
          proRead.changeBottomNav(index: 0, context: context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        //by using indexedstack.....we can keep the state of the page when switching between them
        body: IndexedStack(
            index: proWatch.currentIndex,
            //there are two screen screens for profile(student user and college user)
            children: isCollege ? CollegeuserScreens : userScreens),
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

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.isfirstTime});
  final bool isfirstTime;
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(
      initialPage: 0,
      keepPage: false,
    );
    List<Widget> pages = [
      HomeScreen(
        controller: pageController,
        isfirstTime: isfirstTime,
      ),
      ChatListScreen(
        controller: pageController,
      )
    ];
    return PageView(
      controller: pageController,
      restorationId: 'home_page_view',
      children: pages,
    );
  }
}

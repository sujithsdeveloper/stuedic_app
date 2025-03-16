import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/data/app_db.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/create_post_screen.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key, this.isColege = false});
  final bool isColege;

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with SingleTickerProviderStateMixin {
  bool? isStudent;
  bool? isPublic;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
     
      

        final token = await AppUtils.getToken();
        log(token);

        final profileController = context.read<ProfileController>();
        profileController.getCurrentUserData(context: context);
        profileController.getCurrentUserGrid(context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();

    return WillPopScope(
      onWillPop: () async {
        if (proWatch.currentIndex != 0) {
          proRead.chnageBottomNav(index: 0, context: context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: widget.isColege
            ? CollegeuserScreens[proWatch.currentIndex]
            : userScreens[proWatch.currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Transform.translate(
          offset: const Offset(0, 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GradientCircleAvathar(
                onTap: () {
                  AppRoutes.push(context, CreatePostScreen());
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          onTap: (value) {
            proRead.chnageBottomNav(index: value, context: context);
          },
          currentIndex: proWatch.currentIndex,
          selectedItemColor: ColorConstants.secondaryColor,
          unselectedItemColor: Colors.grey,
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

import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/create_post_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/discover_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/home_screen.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile_screen_student.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // late Animation<double> _iconAnimation;
  bool _isOpened = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    context.read<ProfileController>().getCurrentUserData(context: context);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final token = await AppUtils.getToken();
        log(token);
      },
    );
  }

  List<Widget> screens = [
    HomeScreen(),
    DiscoverScreen(),
    Container(),
    Container(),
    ProfileScreenStudent()
  ];
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // void _toggleAnimation() {
  //   setState(() {
  //     _isOpened = !_isOpened;
  //     if (_isOpened) {
  //       _animationController.forward();
  //     } else {
  //       _animationController.reverse();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();
    return WillPopScope(
      onWillPop: () async {
        if (proWatch.currentIndex != 0) {
          proRead.chnageBottomNav(index: 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: screens[proWatch.currentIndex],
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
                // child: Center(
                //   child: AnimatedSwitcher(
                //     duration: const Duration(milliseconds: 150),
                //     transitionBuilder: (child, animation) {
                //       return RotationTransition(
                //           turns: animation, child: child);
                //     },
                //     child: Icon(
                //       _isOpened ? Icons.close : Icons.add,
                //       key: ValueKey<bool>(_isOpened),
                //     ),
                //   ),
                // ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          onTap: (value) {
            proRead.chnageBottomNav(index: value);
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

// class ArcPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..style = PaintingStyle.fill
//       ..isAntiAlias = true;

//     double radius = 120; // Increased radius for a larger arc
//     Offset center = Offset(size.width / 2, size.height / 2 + 7);

//     drawArcSegment(canvas, center, radius, 180, 240, Color(0xff8B8CF7), paint);
//     drawArcSegment(canvas, center, radius, 240, 300, Color(0xff1F2232), paint);
//     drawArcSegment(canvas, center, radius, 300, 360, Color(0xffFEC031), paint);
//   }

//   void drawArcSegment(Canvas canvas, Offset center, double radius,
//       double startAngle, double endAngle, Color color, Paint paint) {
//     paint.color = color;
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       radians(startAngle),
//       radians(endAngle - startAngle),
//       true,
//       paint,
//     );
//   }

//   double radians(double degrees) {
//     return degrees * math.pi / 180;
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

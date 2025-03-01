import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/view/screens/pick_media_screen.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

class StorySection extends StatefulWidget {
  const StorySection({super.key});

  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  List<Map<String, String>> items = [
    {"username": "John", "profileUrl": ""},
    {"username": "Jane", "profileUrl": ""},
    {"username": "Alex", "profileUrl": ""},
  ];

  @override
  Widget build(BuildContext context) {
    final proRead = context.read<AppContoller>();
    final proWatch = context.watch<AppContoller>();
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorConstants.primaryColor,
                      radius: 34,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                          "https://images.pexels.com/photos/1666779/pexels-photo-1666779.jpeg?auto=compress&cs=tinysrgb&w=600",
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 3,
                      right: 3,
                      child: GestureDetector(
                        onTap: () {
                          // FlutterBetterPicker(
                          //         // appbarColor: Colors.white,
                          //         confirmText: 'Continue',
                          //         textColor: ColorConstants.secondaryColor,
                          //         title: Text('Add Story'),
                          //         backgroundDropDownColor:
                          //             ColorConstants.greyColor,
                          //         backgroundColor: Colors.white,
                          //         backBottomColor:
                          //             ColorConstants.secondaryColor,

                          //         maxCount: 1,
                          //         requestType: MyRequestType.all)
                          //     .instagram(context)
                          //     .then(
                          //   (value) {
                          //     setState(() {
                          //       selectedAssetList = value;
                          //     });
                          //   },
                          // );

                          AppRoutes.push(context, PickMediaScreen());
                        },
                        child: GradientCircleAvathar(
                          radius: 20,
                          child: Icon(
                            Icons.add,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Sujith',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                ),
              ],
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final data = items[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    AnimatedGradientRing(
                        index: index,
                        onTap: proWatch.isClickedStoryLoading
                            ? null
                            : () {
                                proRead.onStoryTap(
                                    context: context,
                                    index: index,
                                    name: data['username']!);
                              },
                        profileUrl: data['profileUrl']!),
                    SizedBox(height: 5),
                    Text(
                      data['username']!,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                    )
                  ],
                ),
              );
            },
          ),
        ]));
  }
}

class AnimatedGradientRing extends StatefulWidget {
  final String profileUrl;
  final Function()? onTap;
  final int index;

  const AnimatedGradientRing({
    super.key,
    required this.profileUrl,
    this.onTap,
    required this.index,
  });

  @override
  _AnimatedGradientRingState createState() => _AnimatedGradientRingState();
}

int generateRandomTime() {
  final random = Random();
  int minTime = 100;
  int maxTime = 2000;
  return minTime + random.nextInt(maxTime - minTime + 1);
}

class _AnimatedGradientRingState extends State<AnimatedGradientRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: generateRandomTime()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<AppContoller>();

    if (proWatch.tappedStoryIndex == widget.index) {
      _controller.repeat();
    } else {
      _controller.stop();
      _controller.value = 0;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GradientRingPainter(proWatch.tappedStoryIndex == widget.index
              ? _controller.value
              : 0),
          child: Padding(
            padding:
                const EdgeInsets.all(1),
            child: GestureDetector(
              onTap: widget.onTap,
              child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AppUtils.getProfile(url: widget.profileUrl)),
            ),
          ),
        );
      },
    );
  }
}

class GradientRingPainter extends CustomPainter {
  final double progress;

  GradientRingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
        center: size.center(Offset.zero), radius: size.width / 2);
    final SweepGradient gradient = SweepGradient(
      colors: [
        ColorConstants.primaryColor,
        ColorConstants.primaryColor2,
        ColorConstants.primaryColor,
        ColorConstants.primaryColor2
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
      transform: GradientRotation(2 * pi * progress),
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant GradientRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

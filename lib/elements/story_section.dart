import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/view/screens/story/story_asset_picker_screen.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

class StorySection extends StatefulWidget {
  const StorySection({super.key});
  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  @override
  Widget build(BuildContext context) {
    final proRead = context.read<AppContoller>();
    final proWatch = context.watch<AppContoller>();
    final proWatchUser = context.watch<ProfileController>();
    final storyProwatch = context.watch<StoryController>();
    final homeStories = storyProwatch.getstorymodel?.response?.groupedStories;
    // final storyProwatch = context.watch<StoryController>();
    final profileUrl = proWatchUser.userCurrentDetails?.response?.profilePicUrl;
    final profileName = proWatchUser.userCurrentDetails?.response?.userName;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            (homeStories == null || homeStories.isEmpty)
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () {
                        AppRoutes.push(context, AssetPickerPage());
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: ColorConstants.primaryColor,
                                radius: 34,
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundImage: AppUtils.getProfile(
                                      url: profileUrl ?? ''),
                                ),
                              ),
                              Positioned(
                                bottom: 3,
                                right: 3,
                                child: GradientCircleAvathar(
                                  radius: 20,
                                  child: Icon(
                                    Icons.add,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            profileName ?? 'Unknown user',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: homeStories?.length ?? 0,
                    itemBuilder: (context, index) {
                      final homeStory = homeStories?[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                        child: Column(
                          
                          children: [
                            Stack(
                              children: [
                                AnimatedGradientRing(
                                    index: index,
                                    onTap: proWatch.isClickedStoryLoading
                                        ? null
                                        : () {
                                            proRead.onStoryTap(
                                                context: context,
                                                index: index,
                                                url: homeStory?.profilePicUrl ??
                                                    '',
                                                name: homeStory?.authorName ??
                                                    'unknown user');
                                          },
                                    profileUrl: homeStory?.profilePicUrl ?? ''),
                                Positioned(
                                    bottom: 3,
                                    right: 3,
                                    child: Builder(
                                      builder: (context) {
                                        if (index == 0) {
                                          return GestureDetector(
                                            onTap: () {
                                              AppRoutes.push(
                                                  context, AssetPickerPage());
                                            },
                                            child: GradientCircleAvathar(
                                              radius: 20,
                                              child: Icon(
                                                Icons.add,
                                                size: 12,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    )),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              homeStory?.authorName ?? 'Unknown user',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 10),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ])),
    );
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
            padding: const EdgeInsets.all(1),
            child: GestureDetector(
              onTap: widget.onTap,
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: ColorConstants.greyColor,
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
        const Color.fromARGB(255, 208, 216, 54),
        const Color.fromARGB(255, 156, 197, 42),
        ColorConstants.primaryColor,
        const Color.fromARGB(255, 102, 221, 46)
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
      transform: GradientRotation(2 * pi * progress),
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant GradientRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

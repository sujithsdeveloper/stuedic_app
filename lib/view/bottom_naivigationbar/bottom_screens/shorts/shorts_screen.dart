import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/shorts_controller.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/players/network_video_player.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/shorts/bottm_app_bar.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/shorts/shorts_screen_stack_items.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<int> scaleAnimation;
  final commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 90),
        lowerBound: 1,
        upperBound: 1.5);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final url = context
              .read<ShortsController>()
              .getShortsModel
              ?.response?[0]
              .postContentUrl
              .toString() ??
          '';

      context.read<ShortsController>().getReels(context: context);
      // context.read<VideoTypeController>().initialiseNetworkVideo(url: url);
      // context.read<VideoTypeController>().notifyListeners();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    // final videoController =
    //     context.read<VideoTypeController>().networkVideoController;
    // if (videoController != null) {
    //   videoController.dispose();
    // }
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final proWatch = context.watch<ShortsController>();
    final reels = proWatch.getShortsModel?.response;

    return Scaffold(
      body: PreloadPageView.builder(
        scrollDirection: Axis.vertical,
        preloadPagesCount: 3,
        itemCount: reels?.length ?? 0,
        pageSnapping: true,
        itemBuilder: (context, index) {
          final reel = reels?[index];

          return Column(
            children: [
              Stack(
                children: [
                  NetworkVideoPlayer(
                    // isGestureControll: true,
                    inistatePlay: false,
                    url: reel?.postContentUrl.toString() ?? '',
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    right: 10,
                    child: TopBar(reel: reel),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: BottomCaption(reel: reel),
                  ),
                ],
              ),
              ShortsBottomBar(
                  animationController: animationController,
                  commentController: commentController)
            ],
          );
        },
      ),
    );
  }
}

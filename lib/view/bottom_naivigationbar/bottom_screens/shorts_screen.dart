import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/shorts_controller.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/players/network_video_player.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ShortsController>().getReels(context: context);
    context.read<VideoTypeController>().onLongPressEnd();
    context.read<VideoTypeController>().notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<ShortsController>();
    final proRead = context.read<ShortsController>();
    final reels = proWatch.getShortsModel?.response;

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reels?.length ?? 0,
        onPageChanged: (value) {
          Provider.of<VideoTypeController>(context, listen: false)
              .controller
              .play();
        },
        itemBuilder: (context, index) {
          final reel = reels?[index];

          return Column(
            children: [
              Stack(
                children: [
                  NetworkVideoPlayer(
                    isGestureControll: true,
                    inistatePlay: true,
                    url: reel?.postContentUrl.toString() ?? '',
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    right: 10,
                    child: ListTile(
                      leading: const CircleAvatar(radius: 16),
                      title: Text(
                        reel?.username ?? 'unknown user',
                        style: StringStyle.normalTextBold(
                            size: 12),
                      ),
                      subtitle: Text(
                        reel?.userId ?? '',
                        style: StringStyle.normalText(
                             size: 10),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                  reel?.isFollowed ?? false
                                      ? 'unfollow'
                                      : 'Follow',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Text(
                      reel?.postDescription ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style:
                          StringStyle.normalText( size: 12),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Visibility(
                    visible: proWatch.isBuffering || !proWatch.isInitialised,
                    child: LinearProgressIndicator(
                      color: ColorConstants.primaryColor2,
                      backgroundColor: ColorConstants.greyColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text(reel?.likescount.toString() ?? '0',
                                style: StringStyle.smallText(isBold: true)),
                            const SizedBox(width: 5),
                            Text('Likes', style: StringStyle.smallText()),
                          ],
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              const Icon(
                                  HugeIcons.strokeRoundedMessageMultiple01,
                                  color: Colors.black),
                              const SizedBox(width: 5),
                              Text(reel?.commentsCount.toString() ?? '0',
                                  style: StringStyle.smallText(isBold: true)),
                              const SizedBox(width: 5),
                              Text('Comments', style: StringStyle.smallText()),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => shareBottomSheet(context),
                          icon: const Icon(HugeIcons.strokeRoundedShare05,
                              color: Colors.black),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.bookmark,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

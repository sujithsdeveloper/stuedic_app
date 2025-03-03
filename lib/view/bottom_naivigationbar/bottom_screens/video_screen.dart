import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/shorts_controller.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (context, index) {
          return VideoPage(
            index: index,
            key: ValueKey(index),
          );
        },
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.index});
  final int index;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ShortsController>()
        .initialiseVideo(url: videoUrls[widget.index]);
    context.read<ShortsController>().onLongPressEnd();
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<ShortsController>();
    final proRead = context.read<ShortsController>();

    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onDoubleTap: () {},
              onLongPress: proRead.onLongPress,
              onLongPressEnd: (details) => proRead.onLongPressEnd(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
                color: Colors.grey,
                child: proWatch.isInitialised
                    ? AspectRatio(
                        aspectRatio: 9 / 16,
                        child: VideoPlayer(proWatch.videoController),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              right: 10,
              child: ListTile(
                leading: const CircleAvatar(radius: 16),
                title: Text(
                  'nameeee',
                  style:
                      StringStyle.normalTextBold(color: Colors.white, size: 12),
                ),
                subtitle: Text(
                  '1 min',
                  style: StringStyle.normalText(color: Colors.white, size: 10),
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
                      child: const Center(
                        child: Text('Follow',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz, color: Colors.white),
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
                "Video description here...",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: StringStyle.normalText(color: Colors.white, size: 12),
              ),
            ),
          ],
        ),
        Column(
          children: [
            LinearProgressIndicator(
              color: ColorConstants.primaryColor2,
              backgroundColor: ColorConstants.greyColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text('349', style: StringStyle.smallText(isBold: true)),
                      const SizedBox(width: 5),
                      Text('Likes', style: StringStyle.smallText()),
                    ],
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(HugeIcons.strokeRoundedMessageMultiple01,
                            color: Colors.black),
                        const SizedBox(width: 5),
                        Text('No', style: StringStyle.smallText(isBold: true)),
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
  }
}

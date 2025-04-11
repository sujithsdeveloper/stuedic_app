import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:video_player/video_player.dart';

class AssetVideoPlayer extends StatefulWidget {
  AssetVideoPlayer({super.key, this.videoFile, this.inistatePlay = true});
  final File? videoFile;
  final bool inistatePlay;
  @override
  State<AssetVideoPlayer> createState() => _AssetVideoPlayerState();
}

class _AssetVideoPlayerState extends State<AssetVideoPlayer> {
  late VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile!)
      ..initialize().then(
        (value) {
          if (widget.inistatePlay) {
            // controller.play();
          }
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWacth = context.watch<VideoTypeController>();
    final proRead = context.read<VideoTypeController>();
    return GestureDetector(
      onTap: () {
        // log(pickedVideoRatio.toString());
        // proRead.togglePlayPause(controller);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.grey,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.82,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !controller.value.isPlaying,
            child: Center(
              child: Opacity(
                opacity: 0.7,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: ColorConstants.secondaryColor,
                  child: Icon(
                    proWacth.isMuted ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

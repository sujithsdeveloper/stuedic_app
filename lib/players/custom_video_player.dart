import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/assetVideoController.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({super.key, required this.videoFile});
  final File videoFile;
  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    context
        .read<Assetvideocontroller>()
        .initialiseVideo(controller: controller, file: widget.videoFile);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWacth = context.watch<Assetvideocontroller>();
    final proRead = context.read<Assetvideocontroller>();
    return GestureDetector(
      onTap: () {
        // log(pickedVideoRatio.toString());
        proRead.togglePlayPause(controller: controller);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
                aspectRatio: proWacth.pickedVideoRatio,
                child: VideoPlayer(controller)),
          ),
          Visibility(
            visible: !proWacth.isPlaying,
            child: Center(
              child: Opacity(
                opacity: 0.7,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: ColorConstants.secondaryColor,
                  child: Icon(
                    proWacth.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

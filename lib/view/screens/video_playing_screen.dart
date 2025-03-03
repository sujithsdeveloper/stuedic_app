import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/assetVideoController.dart';
import 'package:stuedic_app/controller/video_edit_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayingScreen extends StatefulWidget {
  const VideoPlayingScreen({super.key, required this.file});
  final File file;
  @override
  State<VideoPlayingScreen> createState() => _VideoPlayingScreenState();
}

class _VideoPlayingScreenState extends State<VideoPlayingScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    context
        .read<Assetvideocontroller>()
        .initialiseVideo(controller: controller, file: widget.file);
        controller.play();
  }

@override
  void dispose() {
    super.dispose();
    controller.pause();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_outlined))
        ],
      ),
      body: AspectRatio(
        aspectRatio: 9 / 16,
        child: GestureDetector(
     
          
          child: VideoPlayer(controller)),
      ),
    );
  }
}

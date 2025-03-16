import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/video/picker_video_controller.dart';
import 'package:video_player/video_player.dart';

class PickmediaVideoPlayer extends StatefulWidget {
  const PickmediaVideoPlayer({super.key, required this.file});
final File file;
  @override
  State<PickmediaVideoPlayer> createState() => _PickmediaVideoPlayerState();
}

class _PickmediaVideoPlayerState extends State<PickmediaVideoPlayer> {
  @override
  void initState() {
    super.initState();
    Provider.of<PickerVideoController>(context).initVideo(file: widget.file);
  }
  @override
  Widget build(BuildContext context) {
    final proWatch=context.watch<PickerVideoController>();
    final proRead=context.read<PickerVideoController>();
    return GestureDetector(
      onTap: () {
        proRead.onTap();
      },
      child: VideoPlayer(proWatch.controller));
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/video/video_trim_controller.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.file});
  final File file;
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VideoTrimController>().loadVideo(file: widget.file);
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<VideoTrimController>();
    final proRead = context.read<VideoTrimController>();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(child: VideoViewer(trimmer: proWatch.trimmer)),
          SizedBox(
            height: 20,
          ),
          TrimViewer(trimmer: proWatch.trimmer,
          onChangeStart: (startValue) {
            proRead.onChangeStart(startValue);
          },
          onChangeEnd: (endValue) {
            proRead.onChangeEnd(endValue);
          },
          
          )
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/video/video_trim_controller.dart';

class TrimVideoScreen extends StatefulWidget {
  const TrimVideoScreen({super.key, required this.file});
  final File file;
  @override
  State<TrimVideoScreen> createState() => _TrimVideoScreenState();
}

class _TrimVideoScreenState extends State<TrimVideoScreen> {
  @override
  void initState() {
    super.initState();
    // context.read<VideoTrimController>().loadVideo(file: widget.file);
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<VideoTrimController>();
    final proRead = context.read<VideoTrimController>();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
  
        ],
      ),
    );
  }
}

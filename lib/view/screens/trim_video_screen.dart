import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/video_edit_controller.dart';

class TrimVideoScreen extends StatefulWidget {
  final File file;

  TrimVideoScreen({required this.file});

  @override
  _TrimVideoScreenState createState() => _TrimVideoScreenState();
}

class _TrimVideoScreenState extends State<TrimVideoScreen> {
  late VideoEditController videoController;

  // @override
  // void initState() {
  //   super.initState();
  //   videoController = context.read<VideoEditController>();
  //   videoController.loadPickedVideo(widget.file);
  // }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<VideoEditController>();
    final proRead = context.read<VideoEditController>();
    return Scaffold();
    // return Scaffold(
    //     appBar: AppBar(title: Text('Trim Video')),
    //     body: Builder(
    //       builder: (context) {
    //         if (proWatch.isVideoLoaded) {
    //           return Column(
    //             children: [
    //               // Expanded(
    //               //   child: VideoViewer(trimmer: proWatch.trimmer),
    //               // ),
    //               // TrimViewer(
    //               //   trimmer: proWatch.trimmer,
    //               //   viewerHeight: 50.0,
    //               //   viewerWidth: MediaQuery.of(context).size.width,
    //               //   maxVideoLength: Duration(seconds: 30),
    //               //   onChangeStart: proWatch.setStartValue,
    //               //   onChangeEnd: proWatch.setEndValue,
    //               //   onChangePlaybackState: (isPlaying) {},
    //               // ),
    //               ElevatedButton(
    //                 onPressed: () async {
    //                   String? trimmedPath = await proRead.saveTrimmedVideo();
    //                   if (trimmedPath != null) {
    //                     print("Trimmed video saved at: $trimmedPath");
    //                   }
    //                 },
    //                 child: Text('Trim Video'),
    //               ),
    //             ],
    //           );
    //         } else {
    //           return Center(child: CircularProgressIndicator());
    //         }
    //       },
    //     ));
  }
}

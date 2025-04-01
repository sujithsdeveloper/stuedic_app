import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/video/video_trim_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:video_trimmer/video_trimmer.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoTrimController>().loadVideo(file: widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<VideoTrimController>();
    return WillPopScope(
      onWillPop: ()async {
        context.watch<AssetPickerController>().pickedVideo=null;
        return true;

      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Trim Your Video',
            style: StringStyle.appBarText(context: context),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              width: double.infinity,
              child: proWatch.trimmer != null
                  ? VideoViewer(
                      trimmer: proWatch.trimmer!,
                      borderColor: ColorConstants.primaryColor,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            proWatch.trimmer != null
                ? TrimViewer(
                    trimmer: proWatch.trimmer!,
                    viewerHeight: 50,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: const Duration(seconds: 30),
                    onChangeStart: (value) =>
                        context.read<VideoTrimController>().setStartValue(value),
                    onChangeEnd: (value) =>
                        context.read<VideoTrimController>().setEndValue(value),
                    onChangePlaybackState: (value) =>
                        context.read<VideoTrimController>().setPlayingState(value),
                  )
                : Container(),
            ElevatedButton(
              onPressed: () async {
                await context.read<VideoTrimController>().trimVideo();
              },
              child: const Text('Trim Video'),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/controller/story/story_picker_controller.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetPickerPage extends StatelessWidget {
  final PageController? pageController;
  final bool isPost;
  const AssetPickerPage({super.key, this.pageController, this.isPost = false});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return ChangeNotifierProvider(
      create: (_) => StoryPickerController()
        ..pickAssets(context, pageController: pageController),
      child: Consumer<StoryPickerController>(
        builder: (context, storyPicker, child) {
          final proWatch =
              Provider.of<MutlipartController>(context, listen: false);
          return WillPopScope(
            onWillPop: () async {
              if (pageController == null) {
                return true;
              } else {
                pageController?.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
                return false;
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Add Story",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                actions: [
                  TextButton(
                    onPressed: () => storyPicker.uploadMedia(context, proWatch),
                    child: const Icon(Icons.arrow_forward),
                  )
                ],
              ),
              body: storyPicker.selectedAssets.isEmpty
                  ? const Center(child: Text("No media selected"))
                  : SingleChildScrollView(
                      child: FutureBuilder<File?>(
                        future: storyPicker.selectedAssets.first.file,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            final file = snapshot.data!;
                            if (storyPicker.selectedAssets.first.type ==
                                AssetType.image) {
                              context.read<MutlipartController>().uploadMedia(
                                  context: context,
                                  filePath: file.path,
                                  API: APIs.uploadPicForPost);
                              storyPicker.uploadMedia(context, proWatch);

                              return Column(
                                spacing: 20,
                                children: [
                                  Image.file(file, fit: BoxFit.cover),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: TextfieldWidget(
                                      hint: 'Caption',
                                      maxLength: 300,
                                      controller: controller,
                                    ),
                                  ),
                                  SizedBox(height: 20)
                                ],
                              );
                            } else {
                              context.read<MutlipartController>().uploadMedia(
                                  context: context,
                                  filePath: file.path,
                                  isVideo: true,
                                  API: APIs.uploadPicForPost);

                              storyPicker.uploadMedia(context, proWatch);
                              return Column(
                                spacing: 20,
                                children: [
                                  VideoPlayerWidget(file: file),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: TextfieldWidget(
                                      hint: 'Caption',
                                      maxLength: 300,
                                      controller: controller,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              );
                            }
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File file;
  const VideoPlayerWidget({super.key, required this.file});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

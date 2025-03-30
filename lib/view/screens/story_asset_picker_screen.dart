import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/API_controller.dart/story_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:video_player/video_player.dart';

class AssetPickerPage extends StatefulWidget {
  final PageController? pageController;
  final bool isPost;
  const AssetPickerPage({super.key, this.pageController, this.isPost = false});

  @override
  State<AssetPickerPage> createState() => _AssetPickerPageState();
}

class _AssetPickerPageState extends State<AssetPickerPage> {
  List<AssetEntity> selectedAssets = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => pickAssets());
  }

  Future<void> pickAssets() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.common,
        specialItemPosition: SpecialItemPosition.none,
      ),
    );

    if (result == null || result.isEmpty) {
      if (widget.pageController == null) {
        if (mounted) Navigator.pop(context);
      } else {
        widget.pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      setState(() {
        selectedAssets = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = Provider.of<MutlipartController>(context, listen: false);
    final isStoryUploading = context.watch<StoryController>().isStoryUploading;
    return WillPopScope(
      onWillPop: () async {
        if (widget.pageController == null) {
          return true;
        } else {
          widget.pageController!.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
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
            Builder(builder: (context) {
              if (proWatch.isUploading || isStoryUploading) {
                return loadingIndicator();
              } else {
                return TextButton(
                    onPressed: () {
                      if (selectedAssets.isNotEmpty) {
                        final imgurl = proWatch.imageUrl;
                        final videourl = proWatch.videoUrl;
                        selectedAssets.first.file.then((file) {
                          if (file != null) {
                            if (selectedAssets[0].type == AssetType.video) {
                              proWatch
                                  .uploadMedia(
                                context: context,
                                filePath: file.path,
                                isVideo: true,
                                API: APIs.uploadPicForPost,
                              )
                                  .then(
                                (value) async {
                                  await context
                                      .read<StoryController>()
                                      .addStory(
                                          context: context,
                                          url: videourl!,
                                          caption: controller.text);
                                },
                              );
                            } else {
                              proWatch
                                  .uploadMedia(
                                context: context,
                                filePath: file.path,
                                API: APIs.uploadPicForPost,
                              )
                                  .then(
                                (value) async {
                                  await context
                                      .read<StoryController>()
                                      .addStory(
                                          context: context,
                                          url: imgurl!,
                                          caption: controller.text);
                                },
                              );
                            }
                          }
                        });
                      }
                    },
                    child: const Icon(Icons.arrow_forward));
              }
            })
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: selectedAssets.isEmpty
                  ? const Center(child: Text("No media selected"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: selectedAssets.length,
                      itemBuilder: (context, index) {
                        final asset = selectedAssets[index];
                        return FutureBuilder<File?>(
                          future: asset.file,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              final file = snapshot.data!;
                              if (asset.type == AssetType.image) {
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
                                    )
                                  ],
                                );
                              } else if (asset.type == AssetType.video) {
                                return Column(
                                  spacing: 20,
                                  children: [
                                    VideoPlayerWidget(file: file),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: TextfieldWidget(
                                        hint: 'Caption',
                                        controller: controller,
                                        maxLength: 300,
                                      ),
                                    )
                                  ],
                                );
                              }
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
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

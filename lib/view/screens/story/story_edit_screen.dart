import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:stuedic_app/controller/story/story_edit_controller.dart';
import 'package:stuedic_app/dialogs/custom_alert_dialog.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/model/app/overlay_text.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/shortcuts/app_shortcuts.dart';
import 'package:stuedic_app/view/screens/story/video_edit_section.dart';
import 'package:stuedic_app/view/screens/story/widgets/filter_button.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class StoryEditScreen extends StatefulWidget {
  final File file;
  final AssetType assetType;
  const StoryEditScreen(
      {super.key,
      required this.file,
      required this.assetType,
      required this.textController});
  final TextEditingController textController;
  @override
  State<StoryEditScreen> createState() => _StoryEditScreenState();
}

class _StoryEditScreenState extends State<StoryEditScreen> {
  final GlobalKey _editKey = GlobalKey();
  // For video
  VideoPlayerController? videoController;
  final TransformationController transformationController =
      TransformationController();

  int? draggingOverlayIndex;
  Offset? draggingOffset;
  bool isNearDelete = false;

  final double deleteIconSize = 60;
  final double deleteIconEnlarge = 80;
  final double deleteIconPadding = 0;

  @override
  void initState() {
    super.initState();
    if (widget.assetType == AssetType.video) {
      videoController = VideoPlayerController.file(widget.file)
        ..initialize().then((_) {
          setState(() {});
          videoController?.play();
          videoController?.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<StoryEditController>();
    final proRead = context.read<StoryEditController>();
    final proWatchMediaUpload =
        Provider.of<MutlipartController>(context, listen: false);
    final proWatchStory = context.watch<StoryController>();
    final mediaWidget = widget.assetType == AssetType.image
        ? FutureBuilder<Size>(
            future: getImageSize(widget.file),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final imageSize = snapshot.data!;
              const targetAspect = 9 / 16;
              final containerHeight = context.screenHeight;
              final containerWidth = containerHeight * targetAspect;
              return RepaintBoundary(
                key: _editKey,
                // Wrap the widget with RepaintBoundary
                child: ColorFiltered(
                  colorFilter: proWatch.colorFilter ??
                      const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                  //////////////////MediaWidget section///////////////////////////////////////////////////////////mediaWidget section///////////////////////////////////////////////////////////
                  child: Center(
                    child: Container(
                      width: containerWidth,
                      height: containerHeight,
                      color: Colors.black,
                      child: GestureDetector(
                        onTap: () {
                          proRead
                              .toggleTextFieldVisibility(widget.textController);
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: containerWidth,
                              height: containerHeight,
                              child: InteractiveViewer(
                                minScale: 1.0,
                                maxScale: 4.0,
                                alignment: Alignment.center,
                                child: Container(
                                  width: containerWidth,
                                  height: containerHeight,
                                  color: Colors.black,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: SizedBox(
                                      width: imageSize.width,
                                      height: imageSize.height,
                                      child: Image.file(
                                        widget.file,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            /////Overlay section///////////////////////////////////////////////////////////Overlay section///////////////////////////////////////////////////////////
                            // --- Overlay text section ---
                            ...buildOverlays(),
                            Visibility(
                              visible: proWatch.isTextFieldVisible,
                              child: Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: widget.textController,
                                              autofocus: true,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Add text here',
                                                hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : (videoController != null && videoController!.value.isInitialized)
            ? Stack(
                children: [
                  ColorFiltered(
                    colorFilter: proWatch.colorFilter ??
                        const ColorFilter.mode(
                            Colors.transparent, BlendMode.dst),
                    child: AspectRatio(
                      aspectRatio: videoController!.value.aspectRatio,
                      child: VideoPlayer(videoController!),
                    ),
                  ),
                  ...buildOverlays(),
                ],
              )
            : const Center(child: CircularProgressIndicator());

    return Stack(
      children: [
        SizedBox(
          height: context.screenHeight,
          width: double.infinity,
          child: Stack(
            children: [
              SizedBox(
                height: context.screenHeight,
                width: double.infinity,
                child: mediaWidget,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Visibility(
                      visible: proWatch.isFilterVisible,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
///////////Filter section///////////////////////////////////////////////////////////Filter section///////////////////////////////////////////////////////////
                            FilterButtons(context,
                                textEditingController: widget.textController),
                            // ElevatedButton.icon(
                            //   icon: const Icon(Icons.text_fields),
                            //   label: const Text('Add Text'),
                            //   onPressed: addTextOverlay,
                            // ),
                            // Add more editing buttons if needed
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
//////////////////Appbar section///////////////////////////////////////////////////////////AppBar section///////////////////////////////////////////////////////////
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShortcuts.getPlatformDependentPop(
                  color: Colors.white,
                  onPop: () {
                    customDialog(context,
                        title: 'Discard Changes?',
                        subtitle:
                            'Are you sure you want to discard your changes?',
                        actions: [
                          CupertinoDialogAction(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          CupertinoDialogAction(
                              child: const Text('Discard'),
                              onPressed: () {
                                proWatch.overlays.clear();
                                proWatch.selectedFilter = "none";
                                proWatch.isTextFieldVisible = false;
                                proWatch.isFilterVisible = false;
                                Navigator.pop(context);
                                Navigator.pop(context);
                              })
                        ]);
                  },
                ),
                proWatchStory.isStoryUploading ||
                        proWatchMediaUpload.isUploading
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )
                    : RotatedBox(
                        quarterTurns: 1,
                        child: IconButton(
                          onPressed: () async {
                            final multipartController =
                                Provider.of<MutlipartController>(context,
                                    listen: false);
                            AppUtils.showToast(
                                toastMessage: 'Uploading story...');
                            log('Uploading story...');
                            if (proWatch.isTextFieldVisible) {
                              proRead.toggleTextFieldVisibility(
                                  widget.textController);
                            } else if (proWatch.isFilterVisible) {
                              proRead.toggleFilterVisibility();
                            } else // ...inside your share button onPressed...
                            if (widget.assetType == AssetType.video) {
                              log('asset type is video');
                              String? path = await exportEditedVideo(
                                videoPath: widget.file.path,
                                overlays: proWatch.overlays,
                                zoom: transformationController.value
                                    .getMaxScaleOnAxis(),
                                colorFilter: proWatch.colorFilter,
                              );
                              log('exportEditedVideo returned path: $path');
                              if (path == null) {
                                AppUtils.showToast(
                                    toastMessage:
                                        'Failed to export edited video. Please try again.');
                                log('exportEditedVideo failed: returned null path');
                                return;
                              }
                              log('Edited video saved at: $path');
                              await Provider.of<MutlipartController>(context,
                                      listen: false)
                                  .uploadMedia(
                                isVideo: true,
                                context: context,
                                filePath: path,
                                API: ApiUrls.uploadVideo,
                              );
                              String? url = multipartController.videoUrl;
                              if (url != null) {
                                context.read<StoryController>().addStory(
                                      url: url,
                                      caption: widget.textController.text,
                                      context: context,
                                    );

                                proWatch.overlays.clear();
                                proWatch.selectedFilter = "none";
                              }
                            } else {
                              log('asset type is image');
                              String? path = await captureEditedImage();
                              if (path != null) {
                                if (!(proWatchMediaUpload.isUploading) ||
                                    !(proWatchStory.isStoryUploading)) {
                                  log('Edited image saved at: $path');

                                  await multipartController.uploadMedia(
                                    context: context,
                                    filePath: path,
                                    API: ApiUrls.uploadPicForPost,
                                  );
                                  String? url = multipartController.imageUrl;
                                  if (url != null) {
                                    context.read<StoryController>().addStory(
                                          url: url,
                                          caption: widget.textController.text,
                                          context: context,
                                        );

                                    proWatch.overlays.clear();
                                    proWatch.selectedFilter = "none";
                                  }
                                }
                              }
                            }
                          },
                          icon: Icon(
                            size: 30,
                            CupertinoIcons.share,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
//////////////Delete icon section///////////////////////////////////////////////////////////Delete icon section///////////////////////////////////////////////////////////
        if (draggingOverlayIndex != null)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: isNearDelete ? deleteIconEnlarge : deleteIconSize,
                  height: isNearDelete ? deleteIconEnlarge : deleteIconSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    // color: Colors.grey.withOpacity(0.3),
                    // color: isNearDelete
                    //     ? Colors.red.withOpacity(0.3)
                    //     : Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Icon(
                    CupertinoIcons.delete,
                    color: Colors.white,
                    size: isNearDelete ? 40 : null,
                  ))),
            ),
          ),
      ],
    );
  }

////////Render section///////////////////////////////////////////////////////////Render section///////////////////////////////////////////////////////////
  // Helper to render the image or video based on the asset type

  Future<String?> captureEditedImage() async {
    try {
      RenderRepaintBoundary boundary =
          _editKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final buffer = byteData.buffer;
        final directory = await getTemporaryDirectory();
        String filePath =
            '${directory.path}/edited_story_${DateTime.now().millisecondsSinceEpoch}.png';
        File imgFile = File(filePath);
        await imgFile.writeAsBytes(buffer.asUint8List());
        return filePath;
      }
    } catch (e) {
      log('Error capturing image: $e');
      AppUtils.showToast(toastMessage: 'Error capturing image: $e');
    }
    return null;
  }

////ImageSize section///////////////////////////////////////////////////////////ImageSize section///////////////////////////////////////////////////////////

  Future<Size> getImageSize(File file) async {
    final completer = Completer<Size>();
    final image = Image.file(file);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }

///////////OVERLAYS SECTION///////////////////////////////////////////////////////////OVERLAYS SECTION///////////////////////////////////////////////////////////
  List<Widget> buildOverlays() {
    final proWatch = context.watch<StoryEditController>();
    final proRead = context.read<StoryEditController>();
    final overlays = <Widget>[];
    for (int i = 0; i < proWatch.overlays.length; i++) {
      final overlay = proWatch.overlays[i];
      final isDragging = draggingOverlayIndex == i;
      overlays.add(
        Positioned(
          left: isDragging && draggingOffset != null
              ? draggingOffset!.dx
              : overlay.offset.dx,
          top: isDragging && draggingOffset != null
              ? draggingOffset!.dy
              : overlay.offset.dy,
          child: GestureDetector(
            onPanStart: (_) {
              setState(() {
                draggingOverlayIndex = i;
                draggingOffset = overlay.offset;
                isNearDelete = false;
              });
            },
            onPanUpdate: (details) {
              draggingOffset =
                  (draggingOffset ?? overlay.offset) + details.delta;
              // Check if near delete icon
              final screenHeight = context.screenHeight;
              final screenWidth = context.screenWidth;
              final deleteCenter = Offset(
                screenWidth / 2,
                screenHeight - deleteIconPadding - deleteIconSize / 2,
              );
              final textCenter = Offset(
                (draggingOffset!.dx) + 80, // approx text width/2
                (draggingOffset!.dy) + 20, // approx text height/2
              );
              isNearDelete =
                  (deleteCenter - textCenter).distance < (deleteIconSize + 100);
              proRead.notifyListeners();
            },
            onPanEnd: (_) {
              if (isNearDelete && draggingOverlayIndex != null) {
                proRead.overlays.removeAt(draggingOverlayIndex!);
                proRead.notifyListeners();
              } else if (draggingOverlayIndex != null &&
                  draggingOffset != null) {
                proRead.overlays[draggingOverlayIndex!].offset =
                    draggingOffset!;
                proRead.notifyListeners();
              }

              draggingOverlayIndex = null;
              draggingOffset = null;
              isNearDelete = false;
              proRead.notifyListeners();
            },
            child: AnimatedScale(
              scale: isDragging && isNearDelete ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 120),
              child: Text(
                overlay.text,
                style: TextStyle(
                  color: overlay.color,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [const Shadow(blurRadius: 2, color: Colors.black)],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return overlays;
  }

  Positioned overlayText(TextOverlay overlay) {
    return Positioned(
      left: overlay.offset.dx,
      top: overlay.offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            overlay.offset += details.delta;
          });
        },
        child: Text(
          overlay.text,
          style: TextStyle(
            color: overlay.color,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 2, color: Colors.black)],
          ),
        ),
      ),
    );
  }
}

//////////video player section///////////////////////////////////////////////////////////video player section///////////////////////////////////////////////////////////
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
        ? Center(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoPlayer extends StatefulWidget {
  const NetworkVideoPlayer({
    super.key,
    required this.url,
    this.inistatePlay = true,
    this.isGestureControll = false,
    this.controller,
  });

  final String url;
  final bool inistatePlay;
  final bool isGestureControll;
  final VideoPlayerController? controller;

  @override
  State<NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
  VideoPlayerController? videoController;
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      videoController = widget.controller;
      _isOwner = false;
    } else if (widget.url.isNotEmpty) {
      videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((value) {
          setState(() {});
        });
      videoController?.setLooping(true);
      _isOwner = true;
    }
  }

  @override
  void dispose() {
    if (_isOwner && videoController != null) {
      videoController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<VideoTypeController>();
    final proRead = context.read<VideoTypeController>();
    log(widget.url, name: 'reel url');
    if (widget.url.isEmpty) {
      return const Center(child: Text('No video URL provided'));
    }
    final controller = videoController;
    return VisibilityDetector(
      key: Key(widget.url),
      onVisibilityChanged: (visibilityInfo) {
        if (controller != null &&
            controller.value.isInitialized &&
            widget.inistatePlay) {
          if (visibilityInfo.visibleFraction > 0.5) {
            controller.play();
          } else {
            controller.pause();
          }
        }
      },
      child: GestureDetector(
        onLongPress: () {
          proRead.onLongPress(controller!);
        },
        onLongPressEnd: (details) {
          proRead.onLongPressEnd(controller!);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                height: context.screenHeight,
                child: controller != null && controller.value.isInitialized
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller)),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

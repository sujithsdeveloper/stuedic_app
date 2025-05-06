import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NetworkVideoPlayer extends StatefulWidget {
  const NetworkVideoPlayer({
    super.key,
    required this.url,
    this.inistatePlay = true,
    this.isGestureControll = false
  });

  final String url;
  final bool inistatePlay;
  final bool isGestureControll;

  @override
  State<NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    // videoController = Provider.of<VideoTypeController>(context, listen: false);
    videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then(
        (value) {
          setState(() {});
        },
      );

    // videoController.setVolume(1.0);
    // videoController.initialiseNetworkVideo(
    //     url: widget.url, inistatePlay: widget.inistatePlay);
    // videoController.networkVideoController!.addListener(() {
    //   if (mounted) {
    //     setState(() {}); // Update UI only if the widget is still mounted
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<VideoTypeController>();
    final proRead = context.read<VideoTypeController>();
    log(widget.url, name: 'reel url');
    return VisibilityDetector(
      key: Key(widget.url), // Unique key for each video
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5) {
          // proRead.networkVideoController!
          //     .play(); // Play when more than 50% visible
          videoController.play();
        } else {
          // proRead.networkVideoController!.pause();
          // Pause when less than 50% visible
          videoController.pause();
        }
      },
      child: GestureDetector(
        // onTap: () {
        //   if (widget.isGestureControll) {
        //     proRead.toggleMuteUnmute();
        //   } else {
        //     proRead.togglePlayPause(proWatch.controller);
        //   }
        // },
        // onLongPress: () {
        //   if (widget.isGestureControll) {
        //     proRead.onLongPress();
        //   }
        // },
        // onLongPressEnd: (details) {
        //   if (widget.isGestureControll) {
        //     proRead.onLongPressEnd();
        //   }
        // },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.82,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: videoController.value.size.width,
                    height: videoController.value.size.height,
                    child: AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: VideoPlayer(videoController)),
                  ),
                ),
              ),
            ),
            Positioned(
                right: 10,
                bottom: 10,
                // alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    proRead.volumeButtonClick(videoController);
                  },
                  icon: Icon(
                    size: 28,
                    color: Colors.white,
                    proWatch.volume_mute
                        ? Icons.volume_up_rounded
                        : Icons.volume_off,
                  ),
                )),
            // Visibility(
            //   visible: !proWatch.networkVideoController!.value.isPlaying,
            //   child: Center(
            //     child: Opacity(
            //       opacity: 0.7,
            //       child: CircleAvatar(
            //         radius: 25,
            //         backgroundColor: ColorConstants.secondaryColor,
            //         child: Icon(
            //           proWatch.isMuted ? Icons.pause : Icons.play_arrow,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

//   @override
//   void dispose() {
//     if (videoController.networkVideoController!.value.isInitialized) {
//       videoController.networkVideoController!
//           .removeListener(() {}); // Remove listener
//       videoController.networkVideoController!.dispose(); // Dispose controller
//     }
//     super.dispose();
//   }
// }

/*
class NetworkVideoPlayer extends StatefulWidget {
  const NetworkVideoPlayer({
    super.key,
    required this.url,
    this.inistatePlay = true,
    this.isGestureControll = false,
  });

  final String url;
  final bool inistatePlay;
  final bool isGestureControll;

  @override
  State<NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
  late VideoTypeController videoController;

  @override
  void initState() {
    super.initState();
    videoController = Provider.of<VideoTypeController>(context, listen: false);
    videoController.initialiseNetworkVideo(
        url: widget.url, inistatePlay: widget.inistatePlay);
    videoController.networkVideoController!.addListener(() {
      if (mounted) {
        setState(() {
        }); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<VideoTypeController>();
    final proRead = context.read<VideoTypeController>();

    return VisibilityDetector(
      key: Key(widget.url), // Unique key for each video
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5) {
          proRead.networkVideoController!
              .play(); 
        } else {
          proRead.networkVideoController!.pause();
        }
      },
      child: GestureDetector(
        // onTap: () {
        //   if (widget.isGestureControll) {
        //     proRead.toggleMuteUnmute();
        //   } else {
        //     proRead.togglePlayPause(proWatch.controller);
        //   }
        // },
        // onLongPress: () {
        //   if (widget.isGestureControll) {
        //     proRead.onLongPress();
        //   }
        // },
        // onLongPressEnd: (details) {
        //   if (widget.isGestureControll) {
        //     proRead.onLongPressEnd();
        //   }
        // },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.82,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: proWatch.networkVideoController!.value.size.width,
                    height: proWatch.networkVideoController!.value.size.height,
                    child: AspectRatio(
                        aspectRatio:
                            proWatch.networkVideoController!.value.aspectRatio,
                        child: VideoPlayer(proWatch.networkVideoController!)),
                  ),
                ),
              ),
            ),
            // Visibility(
            //   visible: !proWatch.networkVideoController!.value.isPlaying,
            //   child: Center(
            //     child: Opacity(
            //       opacity: 0.7,
            //       child: CircleAvatar(
            //         radius: 25,
            //         backgroundColor: ColorConstants.secondaryColor,
            //         child: Icon(
            //           proWatch.isMuted ? Icons.pause : Icons.play_arrow,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (videoController.networkVideoController!.value.isInitialized) {
      videoController.networkVideoController!
          .removeListener(() {}); // Remove listener
      videoController.networkVideoController!.dispose(); // Dispose controller
    }
    super.dispose();
  }
}

*/

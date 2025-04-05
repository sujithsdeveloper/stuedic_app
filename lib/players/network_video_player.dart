import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    videoController.controller.addListener(() {
      if (mounted) {
        setState(() {}); // Update UI only if the widget is still mounted
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
        if (visibilityInfo.visibleFraction > 0.8) {
          proRead.controller.play(); // Play when more than 50% visible
        } else {
          proRead.controller.pause();
          // Pause when less than 50% visible
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
                    width: proWatch.controller.value.size.width,
                    height: proWatch.controller.value.size.height,
                    child: AspectRatio(
                        aspectRatio: proWatch.controller.value.aspectRatio,
                        child: VideoPlayer(proWatch.controller)),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !proWatch.controller.value.isPlaying,
              child: Center(
                child: Opacity(
                  opacity: 0.7,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: ColorConstants.secondaryColor,
                    child: Icon(
                      proWatch.isMuted ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (videoController.controller.value.isInitialized) {
      videoController.controller.removeListener(() {}); // Remove listener
      videoController.controller.dispose(); // Dispose controller
    }
    super.dispose();
  }
}

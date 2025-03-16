import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoPlayer extends StatefulWidget {
  NetworkVideoPlayer(
      {super.key,
      required this.url,
      this.inistatePlay = true,
      this.isGestureControll = false});
  final String url;
  final bool inistatePlay;
  final bool isGestureControll;
  @override
  State<NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
  @override
  void initState() {
    super.initState();
    Provider.of<VideoTypeController>(context, listen: false)
        .initialiseNetworkVideo(
            url: widget.url, inistatePlay: widget.inistatePlay);
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<VideoTypeController>(context, listen: false)
        .controller
        .dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWacth = context.watch<VideoTypeController>();
    final proRead = context.read<VideoTypeController>();
    return GestureDetector(
      onTap: () {
        if (widget.isGestureControll) {
          proRead.toggleMuteUnmute();
        } else {
          proRead.togglePlayPause();
        }
      },
      onLongPress: () {
        if (widget.isGestureControll) {
          proRead.onLongPress();
        }
      },
      onLongPressEnd: (details) {
        if (widget.isGestureControll) {
          proRead.onLongPressEnd();
          
        }
      },
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
                  width: proWacth.controller.value.size.width,
                  height: proWacth.controller.value.size.height,
                  child: VideoPlayer(proWacth.controller),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !proWacth.isMuted,
            child: Center(
              child: Opacity(
                opacity: 0.7,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: ColorConstants.secondaryColor,
                  child: Icon(
                    proWacth.isMuted ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

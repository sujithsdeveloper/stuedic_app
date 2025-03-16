import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/get_shorts_model.dart';
import 'package:video_player/video_player.dart';

class ShortsController extends ChangeNotifier {
  bool isInitialised = false;
  bool isBuffering = true;
  GetShortsModel? getShortsModel;
  Future<void> getReels({required BuildContext context}) async {
    await ApiCall.get(
        url: APIs.reelAPI,
        onSucces: (p0) {
          // log(p0.body);
          getShortsModel = getShortsModelFromJson(p0.body);
          notifyListeners();
        },
        onTokenExpired: () {
          getReels(context: context);
        },
        context: context);
  }

  // void initialiseVideo({required String url}) {
  //   videoController = VideoPlayerController.networkUrl(Uri.parse(url))
  //     ..addListener(() {
  //       if (videoController.value.isBuffering != isBuffering) {
  //         isBuffering = videoController.value.isBuffering;
  //         notifyListeners();
  //       }
  //     })
  //     ..initialize().then((_) {
  //       isInitialised = true;
  //       isBuffering = false;
  //       notifyListeners();
  //       videoController.play();
  //       videoController.setLooping(true);
  //     }).catchError((error) {
  //       print("Video initialization error: $error");
  //     });
  // }

  // void onLongPress() {
  //   if (videoController.value.isPlaying) {
  //     videoController.pause();
  //   }
  // }

  // void onLongPressEnd() {
  //   if (!videoController.value.isPlaying) {
  //     videoController.play();
  //   }
  // }

  // void disposeVideo() {
  //   if (videoController.value.isInitialized) {
  //     videoController.pause();
  //     videoController.dispose();
  //   }
  // }
}

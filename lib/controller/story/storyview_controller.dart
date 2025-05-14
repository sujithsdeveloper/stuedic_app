// import 'package:flutter/widgets.dart';

// class StoryviewController extends ChangeNotifier {
//     void _loadStory(List stories, int index) async {
//     _videoController?.dispose();
//     _videoController = null;
//     final story = stories[index];
//     final url = story.contentUrl ?? '';
//     final isVideo = url.endsWith('.m3u8');
//     if (isVideo) {
//       _videoController = VideoPlayerController.network(url);
//       await _videoController!.initialize();
//       _videoController!.play();
//       setState(() {});
//       _videoController!.addListener(() {
//         if (_videoController!.value.position >=
//             _videoController!.value.duration) {
//           _nextStory(stories);
//         }
//       });
//     } else {
//       setState(() {});
//       Future.delayed(Duration(seconds: imageStoryDuration), () {
//         if (mounted && currentIndex == index) {
//           _nextStory(stories);
//         }
//       });
//     }
//   }
// }
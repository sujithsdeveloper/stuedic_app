import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:video_player/video_player.dart';

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen(
      {super.key,
      required this.name,
      required this.profileUrl,
      required this.Profileindex});
  final String name;
  final String profileUrl;
  final int Profileindex;

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  int currentIndex = 0;
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _loadStory(List stories, int index) async {
    _videoController?.dispose();
    _videoController = null;
    final story = stories[index];
    final url = story.contentUrl ?? '';
    final isVideo = url.endsWith('.m3u8');
    if (isVideo) {
      _videoController = VideoPlayerController.network(url);
      await _videoController!.initialize();
      _videoController!.play();
      setState(() {});
      _videoController!.addListener(() {
        if (_videoController!.value.position >=
            _videoController!.value.duration) {
          _nextStory(stories);
        }
      });
    } else {
      setState(() {});
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && currentIndex == index) {
          _nextStory(stories);
        }
      });
    }
  }

  void _nextStory(List stories) {
    if (currentIndex < stories.length - 1) {
      setState(() {
        currentIndex++;
      });
      _loadStory(stories, currentIndex);
    } else {
      Navigator.pop(context);
    }
  }

  void _prevStory(List stories) {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _loadStory(stories, currentIndex);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final storyProwatch = context.watch<StoryController>();
    final homeStories = storyProwatch.getstorymodel?.response?.groupedStories;
    final stories = homeStories?[widget.Profileindex].stories ?? [];
    if (stories.isNotEmpty) {
      _loadStory(stories, currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyProwatch = context.watch<StoryController>();
    final homeStories = storyProwatch.getstorymodel?.response?.groupedStories;
    final stories = homeStories?[widget.Profileindex].stories ?? [];
    if (stories.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Text('No stories', style: TextStyle(color: Colors.white))),
      );
    }
    final story = stories[currentIndex];
    final url = story.contentUrl ?? '';
    final isVideo = url.endsWith('.m3u8');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AppUtils.getProfile(url: widget.profileUrl),
            ),
            const SizedBox(width: 10),
            Text(widget.name,
                style:
                    StringStyle.normalTextBold(size: 20, color: Colors.white))
          ],
        ),
      ),
      body: GestureDetector(
        onTapDown: (details) {
          final width = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < width / 3) {
            _prevStory(stories);
          } else if (details.globalPosition.dx > 2 * width / 3) {
            _nextStory(stories);
          }
        },
        child: Stack(
          children: [
            Center(
              child: isVideo
                  ? (_videoController != null &&
                          _videoController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        )
                      : CircularProgressIndicator())
                  : Stack(
                      children: [
                        Image.network(
                          url,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                        Positioned(
                            bottom: 20,
                            right: 0,
                            left: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.remove_red_eye_outlined,
                                    color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  story.viewers ?? '0',
                                  style: StringStyle.normalTextBold(
                                      size: 16, color: Colors.white),
                                ),
                              ],
                            ))
                      ],
                    ),
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(
                  stories.length,
                  (idx) => Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      decoration: BoxDecoration(
                        color:
                            idx <= currentIndex ? Colors.white : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

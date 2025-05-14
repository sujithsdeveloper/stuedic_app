import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:stuedic_app/model/get_story_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/shortcuts/app_shortcuts.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';
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
  int imageStoryDuration = 5;
  VideoPlayerController? _videoController;

  // Add these fields for image story pause/resume
  bool isPaused = false;
  double imageProgress = 0.0;
  Ticker? _ticker;
  Duration _elapsed = Duration.zero;
  Duration _pausedElapsed = Duration.zero; // Add this line

  @override
  void dispose() {
    _videoController?.dispose();
    _ticker?.dispose();
    super.dispose();
  }

  void _startImageTicker(List stories, int index, {Duration? from}) {
    _ticker?.dispose();
    imageProgress = 0.0;
    _elapsed = from ?? Duration.zero;
    _ticker = Ticker((elapsed) {
      if (!isPaused) {
        setState(() {
          _elapsed = (from ?? Duration.zero) + elapsed;
          imageProgress = _elapsed.inMilliseconds / (imageStoryDuration * 1000);
          if (imageProgress >= 1.0) {
            imageProgress = 1.0;
            _ticker?.stop();
            _pausedElapsed = Duration.zero;
            _nextStory(stories);
          }
        });
      }
    });
    _ticker?.start();
  }

  void _pauseStory() {
    setState(() {
      isPaused = true;
      _pausedElapsed = _elapsed; // Save elapsed time at pause
    });
    _ticker?.stop();
    _videoController?.pause();
  }

  void _resumeStory(List stories, int index) {
    setState(() {
      isPaused = false;
    });
    if (_videoController != null) {
      _videoController?.play();
    } else {
      _startImageTicker(stories, index,
          from: _pausedElapsed); // Resume from paused time
    }
  }

  void _loadStory(List stories, int index) async {
    _videoController?.dispose();
    _videoController = null;
    final story = stories[index];
    final url = story.contentUrl ?? '';
    final isVideo = url.endsWith('.m3u8');
    if (isVideo) {
      _ticker?.dispose();
      _ticker = null;
      _pausedElapsed = Duration.zero;
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
      _pausedElapsed = Duration.zero;
      _startImageTicker(stories, index);
      setState(() {});
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

    double videoDurationValue =
        _videoController != null && _videoController!.value.isInitialized
            ? _videoController!.value.position.inSeconds /
                _videoController!.value.duration.inSeconds
            : 0;
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTapDown: (details) {
            final width = MediaQuery.of(context).size.width;
            if (details.globalPosition.dx < width / 3) {
              _prevStory(stories);
            } else if (details.globalPosition.dx > 2 * width / 3) {
              _nextStory(stories);
            }
          },
          onLongPress: () {
            _pauseStory();
          },
          onLongPressUp: () {
            _resumeStory(stories, currentIndex);
          },
          child: Stack(
            children: [
              Center(
                child: isVideo
                    ? (_videoController != null &&
                            _videoController!.value.isInitialized
                        ? VideoStoryView(videoController: _videoController)
                        : CircularProgressIndicator())
                    : ImageStoryView(
                        url: url,
                        story: story,
                        onLongPress: _pauseStory,
                        onLongPressUp: () =>
                            _resumeStory(stories, currentIndex),
                      ),
              ),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: StoryProgressBar(
                  stories: stories,
                  currentIndex: currentIndex,
                  isVideo: isVideo,
                  videoDurationValue: videoDurationValue,
                  imageStoryDuration: imageStoryDuration,
                  imageProgress: imageProgress,
                  isPaused: isPaused,
                ),
              ),
              Positioned(
                  top: 20,
                  child: Row(
                    spacing: 2,
                    children: [
                      AppShortcuts.getPlatformDependentPop(
                        color: Colors.white,
                        onPop: () => Navigator.pop(context),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRoutes.push(context,
                              UserProfile(userId: story.authorId.toString()));
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AppUtils.getProfile(url: widget.profileUrl),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.name,
                                    style: StringStyle.normalTextBold(
                                        size: 20, color: Colors.white)),
                                Text(story.expiresAt.toString(),
                                    style: StringStyle.normalTextBold(
                                        size: 12, color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class StoryProgressBar extends StatelessWidget {
  const StoryProgressBar({
    super.key,
    required this.stories,
    required this.currentIndex,
    required this.isVideo,
    required this.videoDurationValue,
    required this.imageStoryDuration,
    this.imageProgress = 0.0,
    this.isPaused = false,
  });

  final List<Story> stories;
  final int currentIndex;
  final bool isVideo;
  final double videoDurationValue;
  final int imageStoryDuration;
  final double imageProgress;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        stories.length,
        (index) => Expanded(
          child: index < currentIndex
              ? StoryProgressIndicator(
                  value: 1,
                  color: Colors.white,
                )
              : index == currentIndex
                  ? (isVideo
                      ? StoryProgressIndicator(
                          value: videoDurationValue,
                          color: Colors.white,
                        )
                      : StoryProgressIndicator(
                          value: imageProgress,
                          color: Colors.white,
                        ))
                  : StoryProgressIndicator(
                      value: 0,
                    ),
        ),
      ),
    );
  }
}

class ImageStoryView extends StatelessWidget {
  const ImageStoryView({
    super.key,
    required this.url,
    required this.story,
    this.onLongPress,
    this.onLongPressUp,
  });

  final String url;
  final Story story;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressUp;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onLongPress: onLongPress,
          onLongPressUp: onLongPressUp,
          child: Image.network(
            url,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove_red_eye_outlined, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  story.viewers ?? '0',
                  style:
                      StringStyle.normalTextBold(size: 16, color: Colors.white),
                ),
              ],
            ))
      ],
    );
  }
}

class VideoStoryView extends StatefulWidget {
  const VideoStoryView({
    super.key,
    required VideoPlayerController? videoController,
  }) : _videoController = videoController;

  final VideoPlayerController? _videoController;

  @override
  State<VideoStoryView> createState() => _VideoStoryViewState();
}

class _VideoStoryViewState extends State<VideoStoryView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        widget._videoController!.pause();
        setState(() {});
      },
      onLongPressCancel: () {
        widget._videoController!.play();
        setState(() {});
      },
      child: AspectRatio(
        aspectRatio: widget._videoController!.value.aspectRatio,
        child: VideoPlayer(widget._videoController!),
      ),
    );
  }
}

class StoryProgressIndicator extends StatelessWidget {
  const StoryProgressIndicator(
      {super.key, this.value, this.padding = 4, this.color = Colors.grey});
  final double? value;
  final double? padding;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 0),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
    );
  }
}

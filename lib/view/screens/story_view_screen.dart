import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:video_player/video_player.dart';

class StoryViewScreen extends StatelessWidget {
  const StoryViewScreen(
      {super.key,
      required this.name,
      required this.profileUrl,
      required this.Profileindex});
  final String name;
  final String profileUrl;
  final int Profileindex;

  @override
  Widget build(BuildContext context) {
    final storyProwatch = context.watch<StoryController>();
    final homeStories = storyProwatch.getstorymodel?.response?.groupedStories;
    final storyCount = homeStories?[Profileindex].stories?.length ?? 0;

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
          spacing: 20,
          children: [
            CircleAvatar(
              backgroundImage: AppUtils.getProfile(url: profileUrl),
            ),
            Text(name,
                style:
                    StringStyle.normalTextBold(size: 20, color: Colors.white))
          ],
        ),
      ),
      body: FlutterStoryPresenter(
          flutterStoryController: FlutterStoryController(),
          items: List.generate(
            storyCount,
            (index) {
              final story = homeStories?[index].stories?[index];
              return StoryItem(
                videoConfig: StoryViewVideoConfig(
                  cacheVideo: true,
                  loadingWidget: loadingIndicator(),
                  useVideoAspectRatio: true,
                ),
                storyItemType: StoryItemType.custom,
                storyItemSource: StoryItemSource.network,
                customWidget: (context, audioPlayer) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: Image.network(
                          story?.contentUrl ?? "",
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/reel_section_API_call_bloc/bloc/reel_data_fetch_bloc.dart';
import 'package:stuedic_app/controller/API_controller.dart/reel_section_API_call_bloc/bloc/reel_data_fetch_state.dart';
import 'package:stuedic_app/controller/API_controller.dart/shorts_controller.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/players/network_video_player.dart';
import 'package:stuedic_app/sheets/commentBottomSheet.dart';
import 'package:stuedic_app/styles/like_styles.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/shorts/shorts_screen_stack_items.dart';
import 'package:video_player/video_player.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<int> scaleAnimation;
  final commentController = TextEditingController();
  final Map<int, VideoPlayerController> _controllers = {};
  final Set<int> _watchedIndices = {}; // track watched indices
  int _currentIndex = 0;
  final PageController _scrollController = PageController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 90),
        lowerBound: 1,
        upperBound: 1.5);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ReelDataFetchBloc>(context).add(ReelDataFetchEvent());
      // context.read<ShortsController>().getReels(context: context);
      // context.read<VideoTypeController>().initialiseNetworkVideo(url: url);
      // context.read<VideoTypeController>().notifyListeners();
    });
  }

  onpaginationscroll() {
    _scrollController.addListener(() {
      final bloc = BlocProvider.of<ReelDataFetchBloc>(context);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          bloc.isMore) {
        bloc.add(ReelDataFetchEvent());
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _scrollController.dispose();
    _controllers.clear();
    animationController.dispose();
    super.dispose();
  }

  Future<void> _initController(int index, List? reels) async {
    if (reels == null || index < 0 || index >= reels.length) return;
    if (_controllers.containsKey(index)) return;
    final url = reels[index]?.postContentUrl?.toString() ?? '';
    if (url.isEmpty) return;
    final controller = VideoPlayerController.network(url);
    await controller.initialize();
    // controller.setLooping(true);
    _controllers[index] = controller;
    setState(() {});
  }

  void _disposeController(int index) {
    if (_controllers.containsKey(index)) {
      _controllers[index]?.dispose();
      _controllers.remove(index);
    }
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final proWatch = context.watch<ShortsController>();
    final proWatchVideo = context.watch<VideoTypeController>();
    final proReadVideo = context.read<VideoTypeController>();
    final proReadInteraction = context.read<PostInteractionController>();
    final reels = proWatch.getShortsModel?.response;

    if (reels != null && reels.isNotEmpty) {
      _initController(_currentIndex, reels);
      _initController(_currentIndex + 1, reels);
      _initController(_currentIndex - 1, reels);
      _watchedIndices.add(_currentIndex); // mark as watched

      // Only dispose controllers for videos that have never been watched and are not the next video
      for (final idx in _controllers.keys.toList()) {
        if (!_watchedIndices.contains(idx) && (idx - _currentIndex).abs() > 1) {
          _disposeController(idx);
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ReelDataFetchBloc, ReelDataFetchState>(
          builder: (context, state) {
            var bloc = BlocProvider.of<ReelDataFetchBloc>(context);
            if (state is ReelDataFetchLoading) {
              return CircularProgressIndicator();
            }
            if (state is ReelDataFetchSussess || state is ReelDataFetchMore) {
              return PageView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemCount: bloc.blocResponse.length + (bloc.isMore ? 1 : 0),
                pageSnapping: true,
                onPageChanged: (value) async {
                  setState(() {
                    _currentIndex = value;
                    _watchedIndices.add(value); // mark as watched
                  });

                  if (value == bloc.blocResponse.length - 1 && bloc.isMore) {
                    bloc.add(ReelDataFetchEvent());
                  }
                  await _initController(value + 1, reels);
                  await _initController(value - 1, reels);
                  // Only dispose controllers for videos that have never been watched and are not the next video
                  for (final idx in _controllers.keys.toList()) {
                    if (!_watchedIndices.contains(idx) &&
                        (idx - value).abs() > 1) {
                      _disposeController(idx);
                    }
                  }
                },
                itemBuilder: (context, index) {
                  if (index == bloc.blocResponse.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  // final reel = reels?[index];
                  final reel = bloc.blocResponse[index];

                  final controller = _controllers[index];
                  return Stack(
                    children: [
                      NetworkVideoPlayer(
                        inistatePlay: index == _currentIndex,
                        url: reel.postContentUrl.toString(),
                        // url: reel?.postContentUrl.toString() ?? '',
                        controller: controller,
                      ),
                      Positioned(
                        top: 0,
                        left: 10,
                        right: 10,
                        child: TopBar(reel: reel),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 10,
                        right: 10,
                        child: BottomCaption(reel: reel),
                      ),
                      Positioned(
                          right: 10,
                          bottom: 10,
                          child: Column(
                            spacing: 9,
                            children: [
                              Column(
                                children: [
                                  PostLikeStyles(
                                      iconColor: Colors.white,
                                      horizontalDirection: false,
                                      postId: reel.postId ?? '',
                                      likeCount:
                                          reel.likescount.toString() ?? '0',
                                      isLiked: reel.isLiked ?? false,
                                      callBackFunction: () {
                                        // context
                                        //     .read<ShortsController>()
                                        //     .getReels(context: context);
                                      }),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    final comments = proReadInteraction
                                            .getComments?.comments?.reversed
                                            .toList() ??
                                        [];
                                    // commentBottomSheet(
                                    //     context: context,
                                    //     commentController: commentController,
                                    //     postID: reel?.postId ?? '',
                                    //     comments: comments);
                                  },
                                  icon: Icon(
                                    HugeIcons.strokeRoundedMessage01,
                                    color: Colors.white,
                                  )),
                              Icon(
                                size: 28,
                                color: Colors.white,
                                proWatchVideo.volume_mute
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_off,
                              ),
                            ],
                          ))
                    ],
                  );
                },
              );
            }

            if (state is ReelDataFetchError) {
              return Center(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height / 2,
                  child: Text(state.errorMessage),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

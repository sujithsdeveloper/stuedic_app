import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/media_controller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/shimmers_items.dart';
import 'package:video_player/video_player.dart';

class PickMediaScreen extends StatefulWidget {
  const PickMediaScreen({super.key});

  @override
  State<PickMediaScreen> createState() => _PickMediaScreenState();
}

class _PickMediaScreenState extends State<PickMediaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MediaController>().fetchMedia());
  }

  @override
  Widget build(BuildContext context) {
    final proRead = context.read<MediaController>();
    final proWatch = context.watch<MediaController>();

    return WillPopScope(
      onWillPop: () async {
        proWatch.selectedMediaList.clear();
        return await proRead.onPop();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Select Media"),
            actions: [
              TextButton(
                onPressed: () async {},
                child: Text("Continue",
                    style: TextStyle(
                        color: ColorConstants.secondaryColor, fontSize: 16)),
              ),
            ],
          ),
          body: Column(
            children: [
              Builder(
                builder: (context) {
                  if (proWatch.selectedMedia == null) {
                    return SizedBox();
                  }

                  if (proWatch.selectedMedia?.type == AssetType.video) {
                    if (proWatch.file == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return VideoView(
                      file: proWatch.file!,
                    );
                  } else {
                    return ImageView(proWatch: proWatch, proRead: proRead);
                  }
                },
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Consumer<MediaController>(
                        builder: (context, mediaController, _) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<AssetPathEntity>(
                              padding: EdgeInsets.only(left: 20),
                              dropdownColor: Colors.white,
                              menuWidth: 100,
                              isExpanded: true,
                              isDense: true, // Helps with UI spacing
                              value: mediaController.selectedAlbum,
                              items: mediaController.albums.map((album) {
                                return DropdownMenuItem(
                                  value: album,
                                  child: Text(
                                    album.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              }).toList(),
                              onChanged: (AssetPathEntity? newAlbum) {
                                if (newAlbum != null) {
                                  mediaController.loadMediaFromAlbum(newAlbum);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add camera functionality here
                      },
                      icon: Icon(HugeIcons.strokeRoundedCamera01),
                    ),
                  ],
                ),
              ),
              proWatch.mediaList.isEmpty || proWatch.isLoading
                  ? Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: 99, // Placeholder items for shimmer
                        itemBuilder: (context, index) =>
                            ShimmersItems.imagePickerShimmer(),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2),
                          itemCount: proWatch.mediaList.length,
                          itemBuilder: (context, index) {
                            final media = proWatch.mediaList[index];
                            final thumbnail = proWatch.mediaThumbnails[media];

                            return GestureDetector(
                              onTap: () async {
                                proRead.toggleSelection(media, index);

                                log(proWatch.selectedMediaList[index].id);
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  thumbnail != null
                                      ? Image.memory(thumbnail,
                                          fit: BoxFit.cover)
                                      : const Center(
                                          child: CircularProgressIndicator()),
                                  if (media.type == AssetType.video)
                                    const Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: Icon(Icons.videocam,
                                          color: Colors.white),
                                    ),
                                  if (proWatch.selectedIndex == index)
                                    Container(
                                      color: Colors.black45,
                                      child: const Center(
                                        child: Icon(Icons.check_circle,
                                            color: Colors.white, size: 30),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                    ),
            ],
          )),
    );
  }
}

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.proWatch,
    required this.proRead,
  });

  final MediaController proWatch;
  final MediaController proRead;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          color: Colors.white12,
          child: proWatch.selectedMedia != null
              ? FutureBuilder<File?>(
                  future: proWatch.selectedMedia!.file,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox();
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return Image.file(
                        snapshot.data!,
                        fit: proWatch.isCover ? BoxFit.cover : BoxFit.contain,
                      );
                    } else {
                      return const Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey);
                    }
                  },
                )
              : const Center(child: Text("No media selected")),
        ),
        Positioned(
          bottom: 5,
          left: 5,
          child: GestureDetector(
            onTap: () {
              proRead.changeImageFit();
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.fit_screen),
            ),
          ),
        )
      ],
    );
  }
}

class VideoView extends StatefulWidget {
  const VideoView({
    super.key,
    required this.file,
  });
  final File file;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.file)..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ));
  }
}

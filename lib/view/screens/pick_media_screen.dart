import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_designer/story_designer.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
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
  late VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MediaController>().fetchMedia());
  }

  @override
  Widget build(BuildContext context) {
    final proRead = context.read<MediaController>();
    final proWatch = context.watch<MediaController>();
    final proReadAppController = context.read<AppContoller>();
    final proWatchAppController = context.watch<AppContoller>();
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
                onPressed: () async {
                  if (proWatch.selectedMedia != null) {
                    File? selectedFile = await proWatch.selectedMedia!.file;

                    if (selectedFile != null) {
                      String filePath =
                          selectedFile.path; // Extract the file path as String

                      File? editedFile = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StoryDesigner(
                            filePath: filePath, // Pass the String path
                          ),
                        ),
                      );

                      if (editedFile != null) {
                        log("Edited file path: ${editedFile.path}");
                      }
                    } else {
                      log("Failed to retrieve file path");
                    }
                  }
                },
                child: Text("Continue",
                    style: TextStyle(
                        color: ColorConstants.secondaryColor, fontSize: 16)),
              ),
            ],
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.white12,
                    child: proWatch.selectedMedia != null
                        ? FutureBuilder<File?>(
                            future: proWatch.selectedMedia!.file,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasData && snapshot.data != null) {
                                return Image.file(
                                  snapshot.data!,
                                  fit: proWatch.isCover
                                      ? BoxFit.cover
                                      : BoxFit.contain,
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
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(HugeIcons.strokeRoundedCamera01)),
                ),
              ),
              proWatch.mediaList.isEmpty
                  ? Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: 200, // Placeholder items for shimmer
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
                              onTap: () {
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

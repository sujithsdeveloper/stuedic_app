import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/controller/media_controller.dart';

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
                onPressed: () {
                  log(proWatch.selectedMedia.toString());
                },
                child: const Text("Continue",
                    style: TextStyle(color: Colors.blue, fontSize: 16)),
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
                    child: proWatch.selectedMediaList.isNotEmpty
                        ? FutureBuilder<File?>(
                            future: proWatch
                                .selectedMediaList[
                                    proWatch.selectedMediaList.length - 1]
                                .file,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasData && snapshot.data != null) {
                                return Image.file(
                                  snapshot.data!,
                                  fit: proWatchAppController.isCover
                                      ? BoxFit.cover
                                      : null,
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
                        proReadAppController.changeImageFit();
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
                  ? Center(
                      child: CircularProgressIndicator(),
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

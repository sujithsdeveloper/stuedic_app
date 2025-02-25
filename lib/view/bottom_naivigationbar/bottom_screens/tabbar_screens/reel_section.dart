import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';
import 'package:video_player/video_player.dart';

class ReelSection extends StatefulWidget {
  const ReelSection({super.key});

  @override
  State<ReelSection> createState() => _ReelSectionState();
}

class _ReelSectionState extends State<ReelSection> {
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void initializeVideo(File videoFile) async {
    _videoController?.dispose(); // Dispose previous controller if any
    _videoController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {}); // Refresh UI after initialization
        _videoController!.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final proReadAsset = context.read<AssetPickerController>();
    final proWatchAsset = context.watch<AssetPickerController>();
    final multipartObj = context.watch<MutlipartController>();

    if (proWatchAsset.pickedVideo != null) {
      initializeVideo(proWatchAsset.pickedVideo!);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            height: 418,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffF5FFE1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: proWatchAsset.pickedVideo == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GradientButton(
                        label: 'Upload video',
                        onTap: () {
                          mediaBottomSheet(
                            context: context,
                            onCameraTap: () async {
                              await proReadAsset.pickMedia(
                                  context: context,
                                  source: ImageSource.camera,
                                  isVideo: true);
                            },
                            onGalleryTap: () async {
                              await proReadAsset.pickMedia(
                                  context: context,
                                  source: ImageSource.gallery,
                                  isVideo: true);
                            },
                          );
                        },
                      ),
                    ),
                  )
                : _videoController != null &&
                        _videoController!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 10),
          Text(
            'Caption',
            style: StringStyle.normalTextBold(size: 18),
          ),
          const SizedBox(height: 9),
          TextfieldWidget(
            hint: 'Write a caption',
            controller: controller,
            maxLength: 250,
          ),
          const Spacer(),
          GradientButton(
            label: 'Post',
            isColored: true,
            onTap: () {},
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/players/custom_video_player.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/view/screens/media/video_player_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class ReelSection extends StatefulWidget {
  const ReelSection({super.key});

  @override
  State<ReelSection> createState() => _ReelSectionState();
}

class _ReelSectionState extends State<ReelSection> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final proReadAsset = context.read<AssetPickerController>();
    final proWatchAsset = context.watch<AssetPickerController>();
    final multipartObj = context.watch<MutlipartController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
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
              child: Builder(
                builder: (context) {
                  if (proWatchAsset.isLoading) {
                    return loadingIndicator();
                  } else if (proWatchAsset.pickedVideo != null) {
                    return Stack(
                      children: [
                        CustomVideoPlayer(
                            videoFile: proWatchAsset.pickedVideo!),
                        Positioned(
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  proWatchAsset.pickedVideo = null;
                                  proWatchAsset.notifyListeners();
                                },
                                icon: Icon(Icons.delete)))
                      ],
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GradientButton(
                          label: 'Upload video',
                          onTap: () {
                            mediaBottomSheet(
                              isVideo: true,
                              context: context,
                              onCameraTap: (Pickedimage) async {},
                              onGalleryTap: (pickedImage) async {},
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
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
            SizedBox(
              height: 20,
            ),
            GradientButton(
              label: 'Post',
              isColored: true,
              onTap: () {
                AppRoutes.push(context,
                    VideoPlayerScreen(videoFile: proWatchAsset.pickedVideo!));
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

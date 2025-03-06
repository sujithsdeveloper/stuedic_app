

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
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
                child: Center(
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
                )),
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

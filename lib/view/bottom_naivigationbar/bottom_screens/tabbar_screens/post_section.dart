import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class PostSection extends StatelessWidget {
  const PostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final proRead = context.read<CrudOperationController>();
    final proReadAsset = context.read<AssetPickerController>();
    final proWatchAsset = context.watch<AssetPickerController>();
    final multipartObj = context.watch<MutlipartController>();
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 293,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffF5FFE1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: proWatchAsset.pickedImage == null
                      ? GradientButton(
                          label: 'Upload image',
                          onTap: () {
                            mediaBottomSheet(
                                context: context,
                                onCameraTap: () async {
                                  await proReadAsset.pickMedia(
                                      context: context,
                                      source: ImageSource.camera);
                                },
                                onGalleryTap: () async {
                                  await proReadAsset.pickMedia(
                                      context: context,
                                      source: ImageSource.gallery);
                                });
                          },
                        )
                      : Stack(
                          children: [
                            Image.file(proWatchAsset.pickedImage!),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  proReadAsset.pickedImage = null;
                                  proReadAsset.notifyListeners();
                                },
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ),
            Text(
              'Caption',
              style: StringStyle.normalTextBold(size: 18),
            ),
            TextfieldWidget(
              hint: 'Write a caption',
              controller: controller,
              maxLength: 250,
            ),
            GradientButton(
              label: 'Post',
              isColored: true,
              onTap: () {
                if (proWatchAsset.pickedImage == null) {
                  return;
                }

                proRead.uploadPost(
                  
                    imagePath: multipartObj.imageUrl ?? '',
                    caption: controller.text.isEmpty ? '' : controller.text,
                    context: context);
                controller.clear();
                proReadAsset.pickedImage = null;
                proReadAsset.notifyListeners();
                context.read<HomefeedController>().getAllPost(context: context);
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

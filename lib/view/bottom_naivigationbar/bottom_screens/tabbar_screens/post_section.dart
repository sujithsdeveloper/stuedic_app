import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/image/image_edit_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
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
    final proWatchCrop = context.watch<ImageEditController>();
    final controller = TextEditingController();
    bool isDarkTheme = AppUtils.isDarkTheme(context);

    final formKey = GlobalKey<FormState>();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                    color: isDarkTheme
                        ? Color(0xffF5FFE1)
                        : ColorConstants.darkColor2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Builder(
                          builder: (context) {
                            if (proWatchAsset.isLoading ||
                                multipartObj.isUploading) {
                              return loadingIndicator();
                            }
                            if (proWatchAsset.pickedImage == null) {
                              return GradientButton(
                                label: 'Upload image',
                                onTap: () {
                                  mediaBottomSheet(
                                      context: context,
                                      onCameraTap: () async {
                                        await proReadAsset.pickMedia(
                                            context: context,
                                            cropImage: true,
                                            UplaodMedia: true,
                                            source: ImageSource.camera);
                                      },
                                      onGalleryTap: () async {
                                        await proReadAsset.pickImage(
                                            source: ImageSource.gallery,
                                            context: context);
                                      });
                                },
                              );
                            } else {
                              return Stack(
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
                                        context
                                            .read<AssetPickerController>()
                                            .pickedImage = null;
                                        context
                                            .read<AssetPickerController>()
                                            .notifyListeners();
                                      },
                                    ),
                                  )
                                ],
                              );
                            }
                          },
                        )),
                  ),
                ),
                Text(
                  'Caption',
                  style: StringStyle.normalTextBold(size: 18),
                ),
                TextfieldWidget(
                  validator: (p0) => nameValidator(p0, 'Caption'),
                  hint: 'Write a caption',
                  controller: controller,
                  maxLength: 250,
                ),
                GradientButton(
                    label: 'Post',
                    isColored: true,
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        if (proWatchAsset.pickedImage == null) {
                          return;
                        }
                        await proRead.uploadPost(
                            mediaUrl: multipartObj.imageUrl ?? '',
                            caption:
                                controller.text.isEmpty ? '' : controller.text,
                            context: context);
                        controller.clear();
                        proReadAsset.pickedImage = null;
                        proReadAsset.notifyListeners();
                      }

                      // Navigator.pop(context);
                    }),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ));
  }
}

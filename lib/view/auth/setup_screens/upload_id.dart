import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/scanImage_controller.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/view/auth/setup_screens/college_registration.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class IDUpload extends StatefulWidget {
  const IDUpload({super.key});

  @override
  State<IDUpload> createState() => _IDUploadState();
}

class _IDUploadState extends State<IDUpload> {
  final TextEditingController controller = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final proWatchML = context.watch<ScanimageController>();
    final proReadML = context.read<ScanimageController>();
    final proWatch = context.watch<AssetPickerController>();
    final proRead = context.read<AssetPickerController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5),

              /// **Student ID Input Field**
              FormItem(
                title: 'Student ID Number',
                child: TextfieldWidget(
                  onChanged: (p0) {
                    proReadML.verifyText(text: p0!, file: proWatch.pickedImage);
                  },
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Provide the ID Card number';
                    }
                  },
                  controller: controller,
                  keyboardType: TextInputType.number,
                  hint: 'ID Number',
                ),
              ),

              const SizedBox(height: 20),

              /// **Scan ID Card Section**
              Builder(
                builder: (context) {
                  if (proWatch.isLoading) {
                    return SizedBox(
                        height: 397,
                        width: double.infinity,
                        child: loadingIndicator());
                  }
                  if (proWatch.pickedImage == null) {
                    return GestureDetector(
                      onTap: () {
                        mediaBottomSheet(
                          context: context,
                          onCameraTap: (pickedImage) {
                            proReadML.scanImage(image: pickedImage);
                            proReadML.verifyText(
                                text: controller.text,
                                file: proWatch.pickedImage);
                          },
                          onGalleryTap: (pickedImage) {
                            proReadML.scanImage(image: pickedImage);
                            log('picked image: ${pickedImage!.path}');
                            proReadML.verifyText(
                                text: controller.text,
                                file: proWatch.pickedImage);
                          },
                        );
                      },
                      child: Container(
                        height: 397,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                              color: const Color(0xff8CA3FF), width: 2),
                          color: const Color(0xff8CA3FF).withOpacity(0.3),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.qr_code,
                                  color: Colors.black, size: 50),
                              Text(
                                'Scan ID Card',
                                style: StringStyle.normalText(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Stack(
                      children: [
                        Image.file(height: 400, proWatch.pickedImage!),
                        Positioned(
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  proRead.clearAsset();
                                },
                                icon: Icon(Icons.close)))
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              /// **Verify Button**
              GestureDetector(
                onTap: () {
                  if (key.currentState!.validate()) {
                    String extractedText = proWatchML.extractedText ?? "";
                    String inputText = controller.text.trim();

                    if (inputText.isNotEmpty) {
                      if (extractedText.contains(inputText)) {
                        log('Success: Text found!');
                      } else {
                        // log('extracted text: $extractedText');
                        errorSnackbar(
                            label: 'Given ID and ID Number Doesn\'t match',
                            context: context);
                      }
                    }
                  }
                },
                child: Container(
                  height: 36,
                  width: 122,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: proWatchML.isContinue
                        ? const Color(
                            0xff0F0AA3) // Blue when conditions are met
                        : Colors.grey, // Grey when conditions are not met
                  ),
                  child: Center(
                    child: Text(
                      'Verify',
                      style: StringStyle.normalText(color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// **"Maybe Later" Button with Text Check**
              GradientButton(
                label: 'Maybe later',
                width: double.infinity,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

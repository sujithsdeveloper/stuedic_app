import 'package:flutter/material.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';

class UploadProfile extends StatelessWidget {
  const UploadProfile({super.key, required this.prowatch, required this.proRead, required this.nextPage});
final AppContoller prowatch;
final AppContoller proRead;
final Function() nextPage;
  @override
  Widget build(BuildContext context) {
    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              Text(
                                'Upload Photo',
                                style: StringStyle.topHeading(size: 32),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Enhance your profile with a personal touch by adding a photo. Let your picture speak about your identity.',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor:
                                            ColorConstants.primaryColor2,
                                        radius: 64,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                              ImageConstants.avathar),
                                          radius: 62,
                                        )),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          mediaBottomSheet(context: context);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              ColorConstants.secondaryColor,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              GradientButton(
                                width: double.infinity,
                                isColored: true,
                                label: 'Continue',
                                onTap: nextPage,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GradientButton(
                                width: double.infinity,
                                label: 'MayBeLater',
                                onTap: nextPage,
                              ),
                            ],
                          ),
                        ),
                      );
  }
}
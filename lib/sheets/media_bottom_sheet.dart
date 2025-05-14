import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

Future<dynamic> mediaBottomSheet(
    {required BuildContext context,
    bool isVideo = false,
    required Function() onCameraTap,
    required Function() onGalleryTap}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      height: 191,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onCameraTap();
            },
            child: Container(
              height: 112,
              width: 159,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffE7ECF0),
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientCircleAvathar(
                      radius: 48,
                      child: Icon(CupertinoIcons.camera),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Camera',
                      style: StringStyle.normalTextBold(),
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onGalleryTap();
            },
            child: Container(
              height: 112,
              width: 159,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffE7ECF0),
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientCircleAvathar(
                      radius: 48,
                      child: Icon(HugeIcons.strokeRoundedImageAdd01),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Add from Library',
                      style: StringStyle.normalTextBold(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

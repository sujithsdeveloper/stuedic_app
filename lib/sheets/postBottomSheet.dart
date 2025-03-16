import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/storage_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';

dynamic postBottomSheet(
    {required BuildContext context,
    required String imageUrl,
    required String postId,
    required bool isRightUser,
    required String username}) {
  return showModalBottomSheet(
    isScrollControlled: false,
    context: context,
    builder: (context) {
      log("Is right user: $isRightUser");
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        // height: 191,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _sheetItems(
                onTap: () {},
                iconData: CupertinoIcons.bookmark,
                label: 'Save Post',
              ),
              Visibility(
                visible: isRightUser,
                child: _sheetItems(
                  onTap: () {
                    context
                        .read<CrudOperationController>()
                        .deletePost(context: context, postId: postId);
                  },
                  iconData: CupertinoIcons.delete,
                  label: 'Delete Post',
                ),
              ),
              _sheetItems(
                onTap: () {},
                iconData: HugeIcons.strokeRoundedDownload01,
                label: 'Save to gallery',
              ),
              _sheetItems(
                onTap: () {
                  Navigator.pop(context);
                  reportSheet(context: context);
                },
                iconData: HugeIcons.strokeRoundedFlag02,
                label: 'Report',
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _sheetItems extends StatelessWidget {
  const _sheetItems({
    super.key,
    required this.label,
    required this.iconData,
    this.onTap,
    this.textColor,
    this.iconColor,
  });

  final String label;
  final IconData iconData;
  final Function()? onTap;
  final Color? textColor;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        color: iconColor,
        size: 30,
      ),
      title: Text(
        label,
        style: StringStyle.normalText(
            isBold: true,
            color:
                textColor == null ? ColorConstants.secondaryColor : textColor!),
      ),
    );
  }
}

void reportSheet({required BuildContext context}) {
  List<String> reportOptions = [
    "I just don't like it",
    "Bullying or unwanted contact",
    "Suicide, self-injury or eating disorders",
    "Violence, hate or exploitation",
    "Selling or promoting restricted items",
    "Nudity or sexual activity",
    "Scam, fraud or spam",
    "False information"
  ];

  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "Report",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Why are you reporting this post?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: reportOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(reportOptions[index]),
                    onTap: () {
                      Navigator.pop(context);
                      thankYouSheet(context: context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

dynamic thankYouSheet({required BuildContext context}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Lottie.asset(repeat: false, LottieAnimations.tick),
            Text(
              'Thank you for your feedback',
              style: StringStyle.normalTextBold(size: 20),
            ),
            Text(
              'We use these reports to show youb less of this kind of contents in future',
              softWrap: true,
            ),
            Spacer(),
            GradientButton(
              isColored: true,
              label: 'Done',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ),
  );
}

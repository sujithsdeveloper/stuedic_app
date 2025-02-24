import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/storage_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';


dynamic postBottomSheet(
    {required BuildContext context,
    required String imageUrl,
    required String username}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      final proRead = context.read<StorageController>();
      final proWatch = context.watch<StorageController>();
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        height: 191,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _sheetItems(
                onTap: () {
                  Future.delayed(Duration(milliseconds: 300), () {
                    proRead.saveNetworkImage(
                        imageUrl: imageUrl,
                        context: context,
                        username: username);
                  });
                },
                iconData: CupertinoIcons.bookmark,
                label: 'Save Post',
              ),
              _sheetItems(
                onTap: () {},
                iconData: HugeIcons.strokeRoundedDownload01,
                label: 'Save to gallery',
              ),
              _sheetItems(
                onTap: () {},
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

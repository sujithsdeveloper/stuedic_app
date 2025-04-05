import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/controller/story/story_controller.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class StoryPickerController extends ChangeNotifier {
  List<AssetEntity> selectedAssets = [];
  final TextEditingController controller = TextEditingController();

  Future<void> pickAssets(BuildContext context,
      {PageController? pageController}) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.common,
        specialItemPosition: SpecialItemPosition.none,
      ),
    );

    if (result == null || result.isEmpty) {
      if (pageController == null) {
        if (context.mounted) Navigator.pop(context);
      } else {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      selectedAssets = result;
      notifyListeners();
    }
  }

  void uploadMedia(BuildContext context, MutlipartController proWatch) {
    if (selectedAssets.isNotEmpty) {
      final imgurl = proWatch.imageUrl;
      final videourl = proWatch.videoUrl;
      selectedAssets.first.file.then((file) {
        if (file != null) {
          if (selectedAssets[0].type == AssetType.video) {
            log('asset type video');
            context.read<StoryController>().addStory(
                context: context, url: videourl!, caption: controller.text);
          } else {
            log('asset type image');
            context.read<StoryController>().addStory(
                context: context, url: imgurl!, caption: controller.text);
          }
        }
      });
    }
  }
}

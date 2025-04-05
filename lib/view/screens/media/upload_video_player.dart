import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/shorts_controller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/controller/video/video_trim_controller.dart';
import 'package:stuedic_app/players/asset_video_player.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class upload_video_player extends StatefulWidget {
  const upload_video_player({super.key, required this.file});
  final File file;

  @override
  State<upload_video_player> createState() => _upload_video_playerState();
}

class _upload_video_playerState extends State<upload_video_player> {
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoTrimController>().loadVideo(file: widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<MutlipartController>();
    final key = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () async {
        context.watch<AssetPickerController>().pickedVideo = null;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Upload Video',
            style: StringStyle.appBarText(context: context),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    String? url =
                        Provider.of<MutlipartController>(context, listen: false)
                            .videoUrl;
                    if (url == null || url.isEmpty) {
                      errorSnackbar(
                          label: 'Media is Uploading please wait',
                          context: context);
                    } else {
                      context.read<CrudOperationController>().uploadPost(
                          mediaUrl: url,
                          postType: StringConstants.reel,
                          caption: controller.text,
                          context: context);
                    }
                  }
                },
                icon: Icon(Icons.arrow_forward))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              spacing: 20,
              children: [
                Stack(
                  children: [
                    AssetVideoPlayer(
                      videoFile: widget.file,
                      inistatePlay: false,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Visibility(
                        visible: proWatch.isUploading,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              'Uploading video please wait',
                              style: StringStyle.normalText(
                                  isBold: true, size: 20),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextfieldWidget(
                    hint: 'Caption',
                    validator: (p0) => nameValidator(p0, 'Caption'),
                    maxLength: 300,
                    controller: controller,
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/controller/story/story_edit_controller.dart';
import 'package:stuedic_app/controller/story/story_picker_controller.dart';
import 'package:stuedic_app/dialogs/custom_alert_dialog.dart';
import 'package:stuedic_app/view/screens/story/story_edit_screen.dart';

class AssetPickerPage extends StatefulWidget {
  final bool isPost;
  const AssetPickerPage({super.key, this.isPost = false});

  @override
  State<AssetPickerPage> createState() => _AssetPickerPageState();
}

class _AssetPickerPageState extends State<AssetPickerPage> {
  final textController = TextEditingController();
  File? _loadedFile; // Cache the loaded file

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<StoryEditController>();
    final proRead = context.read<StoryEditController>();
    return ChangeNotifierProvider(
      create: (_) => StoryPickerController()..pickAssets(context),
      child: Consumer<StoryPickerController>(
        builder: (context, storyPicker, child) {
          final proReadEdit = context.read<StoryEditController>();
          final proWatch =
              Provider.of<MutlipartController>(context, listen: false);
          return WillPopScope(
            onWillPop: () async {
              
              customDialog(context,
                  titile: 'Discard Changes?',
                  subtitle: 'Are you sure you want to discard your changes?',
                  actions: [
                    CupertinoDialogAction(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    CupertinoDialogAction(
                        child: const Text('Discard'),
                        onPressed: () {
                          proReadEdit.overlays.clear();
                          proReadEdit.selectedFilter = "none";
                          proReadEdit.isTextFieldVisible = false;
                          proReadEdit.isFilterVisible = false;
                          Navigator.pop(context);
                          Navigator.pop(context);
                        })
                  ]);
              return false; // Prevent default back navigation
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: storyPicker.selectedAssets.isEmpty
                    ? const Center(child: Text("No media selected"))
                    : _loadedFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: StoryEditScreen(
                              file: _loadedFile!,
                              assetType: storyPicker.selectedAssets.first.type,
                              textController: textController,
                            ),
                          )
                        : FutureBuilder<File?>(
                            future: storyPicker.selectedAssets.first.file,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                _loadedFile = snapshot.data!;
                                final file = _loadedFile!;
                                final assetType =
                                    storyPicker.selectedAssets.first.type;
                                // Replace direct image/video display with StoryEditWidget
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: StoryEditScreen(
                                    file: file,
                                    assetType: assetType,
                                    textController: textController,
                                  ),
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            proRead.toggleFilterVisibility();
                          },
                          icon: Icon(
                            Icons.filter_hdr_sharp,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            proRead.toggleTextFieldVisibility(textController);
                          },
                          icon: Icon(
                            Icons.text_fields_outlined,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

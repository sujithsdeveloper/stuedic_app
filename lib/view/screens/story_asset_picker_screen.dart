import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetPickerPage extends StatefulWidget {
  final PageController?
      pageController; // Add PageController as an optional parameter
  final bool isPost;
  const AssetPickerPage({super.key, this.pageController, this.isPost = false});

  @override
  State<AssetPickerPage> createState() => _AssetPickerPageState();
}

class _AssetPickerPageState extends State<AssetPickerPage> {
  List<AssetEntity> selectedAssets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => pickAssets());
  }

  Future<void> pickAssets() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.common,
        specialItemPosition: SpecialItemPosition.none, // Full-screen picker
      ),
    );

    if (result == null || result.isEmpty) {
      // If no asset is picked, check if pageController exists
      if (widget.pageController == null) {
        if (mounted) Navigator.pop(context); // Pop if no controller
      } else {
        widget.pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      setState(() {
        selectedAssets = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Story",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          TextButton(onPressed: () {}, child: Icon(Icons.arrow_forward))
        ],
      ),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: pickAssets,
          //   child: const Text("Pick Image"),
          // ),
          Expanded(
            child: selectedAssets.isEmpty
                ? const Center(child: Text("No image selected"))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: selectedAssets.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<Uint8List?>(
                        future: selectedAssets[index].thumbnailDataWithSize(
                          const ThumbnailSize(200, 200),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Center(
                              child: Image.memory(snapshot.data!,
                                  fit: BoxFit.cover),
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

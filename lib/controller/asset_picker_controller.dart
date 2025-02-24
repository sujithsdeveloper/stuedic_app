import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';

class AssetPickerController extends ChangeNotifier {
  File? pickedAsset;

  Future<void> pickImage({
    bool isVideo = false,
    required BuildContext context,
    required ImageSource source,
  }) async {
    ImagePicker picker = ImagePicker();

    if (isVideo) {
      final video = await picker.pickVideo(source: source);
      if (video != null) {
        pickedAsset = File(video.path);
        notifyListeners();
      } else {
        errorSnackbar(label: 'No video selected', context: context);
      }
    } else {
      final image = await picker.pickImage(source: source);
      if (image != null) {
        pickedAsset = File(image.path);

        try {
          Uint8List imageBytes =
              await pickedAsset!.readAsBytes(); // Convert to Uint8List

          final editedImage = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageEditor(

                image: imageBytes, 
              ),
            ),
          ).then((value) {
            if (value != null && value is Uint8List) {
              log("Edited Image Data: ${value.length} bytes");

              // Save edited image
              pickedAsset = File(pickedAsset!.path)..writeAsBytesSync(value);

              context.read<MutlipartController>().uploadMedia(
                    context: context,
                    filePath: pickedAsset!.path,
                    API: APIs.uploadPicForPost,
                    isVideo: false,
                  );
            }
          });

          notifyListeners();
        } catch (e) {
          log("Error converting image: $e");
          errorSnackbar(label: "Error processing image", context: context);
        }
      } else {
        errorSnackbar(label: "No image selected", context: context);
      }
    }
  }
}

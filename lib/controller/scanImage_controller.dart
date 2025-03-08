import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanimageController extends ChangeNotifier {
  String? extractedText;
  bool isContinue = false;

  Future<void> scanImage({File? image}) async {
    log('path : ${image!.path}');

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);

      extractedText = recognizedText.text;
      textRecognizer.close();
      notifyListeners();

      log("Extracted Text: $extractedText");

      // _updateContinueStatus();
    } catch (e) {
      log("Error processing image: $e");
    }
  }

  Future<void> verifyText({required String text, File? file}) async {
    isContinue = false;
    notifyListeners();
    if (file != null && text.isNotEmpty) {
      isContinue = true;
      notifyListeners();
    }
  }
}

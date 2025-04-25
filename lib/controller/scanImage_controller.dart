import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';

class ScanimageController extends ChangeNotifier {
  String? extractedText;
  bool isContinue = false;
  bool isLoading = false;
  bool isVerified = false;

  String? extractedIdNumber;
  final textRecognizer = TextRecognizer();

  Future<void> scanImage(
      {File? image,
      required String idNumber,
      required BuildContext context}) async {
    isVerified = false;
    extractedText = null;
    log('path : ${image!.path}');
    isLoading = true;
    notifyListeners();
    // RegExp to match all numbers in the text
    final numberRegExp = RegExp(r'\d+');

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await textRecognizer.processImage(inputImage);
      extractedText = recognizedText.text;

      // Extract all numbers from the text
      final matches = numberRegExp.allMatches(extractedText ?? '');
      extractedIdNumber = null;
      for (final match in matches) {
        final number = match.group(0);
        if (number == idNumber) {
          isVerified = true;
          extractedIdNumber = number;
          notifyListeners();
          log("ID Number found: $number");
          break;
        } else {
          errorSnackbar(
              label: 'Given ID and ID Number Doesn\'t match', context: context);
        }
      }

      textRecognizer.close();
      isLoading = false;
      notifyListeners();
      log("Extracted Text: $extractedText");
      log("Extracted ID Number: $extractedIdNumber");
    } catch (e) {
      isLoading = false;
      notifyListeners();
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

  void clearData() {
    extractedText = null;
    isContinue = false;
    isLoading = false;
    isVerified = false;
    extractedIdNumber = null;
    notifyListeners();
  }
}

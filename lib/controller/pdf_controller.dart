import 'dart:developer';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';

class PdfController extends ChangeNotifier {
  PDFDocument? document;
  bool isLoading = false;

  Future<void> viewPDF({required BuildContext context, required String url}) async {
    isLoading = true;
    notifyListeners();

    try {
      document = await PDFDocument.fromURL(url);
      if (document == null) {
        throw Exception("Failed to load PDF");
      }
    } catch (e) {
      errorSnackbar(label: 'Unable to load PDF', context: context);
      log(e.toString());
    } finally {
      if (context.mounted) {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}

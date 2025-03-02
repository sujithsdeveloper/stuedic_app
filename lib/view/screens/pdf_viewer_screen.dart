import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/pdf_controller.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key, required this.url});
  final String url;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PdfController>().viewPDF(context: context, url: widget.url);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pdfProvider = context.watch<PdfController>();

    return Scaffold(
      appBar: AppBar(),
      body: pdfProvider.isLoading || pdfProvider.document == null
          ? loadingIndicator()
          : PDFViewer(
              backgroundColor: Colors.white,
              indicatorText: ColorConstants.secondaryColor,
              scrollDirection: Axis.vertical,
              progressIndicator: loadingIndicator(),
              indicatorBackground: ColorConstants.greyColor,
              pickerButtonColor: ColorConstants.primaryColor2,
              showNavigation: false,
              pickerIconColor: ColorConstants.secondaryColor,
              showPicker: false,
              document: pdfProvider.document!),
    );
  }
}

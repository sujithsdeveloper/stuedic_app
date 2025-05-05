import 'package:flutter/material.dart';
import 'package:stuedic_app/model/app/overlay_text.dart';
import 'package:stuedic_app/styles/color_filters.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';

class StoryEditController extends ChangeNotifier {
  String selectedFilter = StringConstants.none;
  bool isTextFieldVisible = false;
  bool isFilterVisible = false;
  final List<TextOverlay> overlays = [];

  ////////Text Field Section///////////////////////////////////////////////////////////Text Field Section///////////////////////////////////////////////////////////
  void toggleTextFieldVisibility(TextEditingController textEditingController) {
    if (!isTextFieldVisible) {
      // Opening text field: hide filter, clear text
      if (isFilterVisible) {
        isFilterVisible = false;
      }
      isTextFieldVisible = true;
      textEditingController.clear();
      notifyListeners();
    } else {
      // Closing text field: add text if not empty, clear text
      isTextFieldVisible = false;
      if (textEditingController.text.trim().isNotEmpty) {
        addText(textEditingController.text, Colors.white);
      }
      textEditingController.clear();
      notifyListeners();
    }
  }

  void addText(String text, Color color) {
    overlays.add(TextOverlay(
      text: text,
      color: color,
      offset: const Offset(50, 50),
    ));
    notifyListeners();
  }

///////////////Filter Section/////////////////////////////////////////////////////////////Filter Section///////////////////////////////////////////////////////////

  void toggleFilterVisibility() {
    if (!isFilterVisible) {
      // Opening filter: hide text field
      if (isTextFieldVisible) {
        isTextFieldVisible = false;
      }
      isFilterVisible = true;
      notifyListeners();
    } else {
      // Closing filter
      isFilterVisible = false;
      notifyListeners();
    }
  }

  void toggleFilter({required String filter}) {
    selectedFilter = filter;

    notifyListeners();
  }

  ColorFilter? get colorFilter {
    switch (selectedFilter) {
      case StringConstants.grayscale:
        return ImageColorFilters.grayscale;
      case StringConstants.sepia:
        return ImageColorFilters.sepia;
      case StringConstants.vintage:
        return ImageColorFilters.vintage;
      case StringConstants.coolBlue:
        return ImageColorFilters.coolBlue;
      case StringConstants.warmGlow:
        return ImageColorFilters.warmGlow;
      case StringConstants.fade:
        return ImageColorFilters.fade;
      case StringConstants.highContrast:
        return ImageColorFilters.highContrast;
      case StringConstants.brighten:
        return ImageColorFilters.brighten;
      case StringConstants.darken:
        return ImageColorFilters.darken;
      case StringConstants.mono:
        return ImageColorFilters.mono;
      case StringConstants.lofi:
        return ImageColorFilters.lofi;
      case StringConstants.rose:
        return ImageColorFilters.rose;
      case StringConstants.night:
        return ImageColorFilters.night;
      case StringConstants.none:
      default:
        return null;
    }
  }
}

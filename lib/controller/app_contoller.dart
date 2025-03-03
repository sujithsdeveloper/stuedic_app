import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/view/screens/story_view_screen.dart';

class AppContoller extends ChangeNotifier {
  bool isObscure = true;
  bool checkBoxCheked = false;
  bool isEmailSelected = true;
  bool isButtonColored = false;
  bool singleFieldColored = false;
  int currentIndex = 0;
  int pageIndex = 0;
  String email = "";
  String phoneNumber = "";
  String password = "";

  void clearState() {
    isEmailSelected = true;
    isButtonColored = false;
    changeMaxLine = false;
    notifyListeners();
  }

  void toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  bool changeMaxLine = false;
  void changeFieldMaxlength(TextEditingController controller) {
    if (controller.text.length > 10) {
      changeMaxLine = true;
      notifyListeners();
    } else {}
  }

  void chnageBottomNav({required int index}) {
    currentIndex = index;
    notifyListeners();
  }

  void toggleCheckBox({required bool value}) {
    checkBoxCheked = value;
    notifyListeners();
  }

  void toggleEmailPhoneNumber(bool value) {
    isEmailSelected = value;
    notifyListeners();
  }

  void changeButtonColor() {
    if ((email.isNotEmpty && password.isNotEmpty) ||
        (!isEmailSelected && phoneNumber.isNotEmpty && password.isNotEmpty)) {
      isButtonColored = true;
    } else {
      isButtonColored = false;
    }
    notifyListeners();
  }

  void changeSingleFeildButtonColor({required String controller}) {
    if (controller.isEmpty) {
      singleFieldColored = true;
    } else {
      singleFieldColored = false;
    }

    notifyListeners();
  }

  bool setupPop({required int index, required PageController pageController}) {
    if (index != 0) {
      pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);

      return false;
    } else {
      return true;
    }
  }

  Set<int> following = {};


  bool isFollowing(int index) {
    return following.contains(index);
  }

  bool isClickedStoryLoading = false;
  int? tappedStoryIndex; // Store the tapped story index

  void onStoryTap({
    required BuildContext context,
    required int index,
    required String name,
  }) {
    isClickedStoryLoading = true;
    tappedStoryIndex = index; // Update tapped story index
    notifyListeners();

    Future.delayed(Duration(seconds: 2)).then((value) {
      isClickedStoryLoading = false;
      tappedStoryIndex = null;
      notifyListeners();

      AppRoutes.push(context, StoryViewScreen(name: name));
    });
  }

  bool isLikeVisible = false;
  void toggleLikeVisible() {
    isLikeVisible = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 1)).then(
      (value) {
        isLikeVisible = false;
        notifyListeners();
      },
    );
  }

  
}

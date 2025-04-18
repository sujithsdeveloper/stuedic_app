import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/home_page_controller.dart';
import 'package:stuedic_app/controller/video_type_controller.dart';
import 'package:stuedic_app/dialogs/desgination_dialog.dart';
import 'package:stuedic_app/routes/app_routes.dart';
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
  String confrimPassword = "";

  void clearState() {
    isEmailSelected = true;
    isButtonColored = false;
    changeMaxLine = false;
    singleFieldColored = false;
    isObscure = true;
    checkBoxCheked = false;
    isEmailSelected = true;
    isButtonColored = false;
    singleFieldColored = false;
    currentIndex = 0;
    pageIndex = 0;
    email = "";
    phoneNumber = "";
    password = "";
    confrimPassword = "";

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

  void chnageBottomNav({required int index, required BuildContext context}) {
    final videoController =
        Provider.of<VideoTypeController>(context, listen: false)
            .networkVideoController;

    if (currentIndex == index) return; // Prevent redundant state changes
    currentIndex = index;

    notifyListeners();

    if (videoController != null && videoController.value.isInitialized) {
      if (currentIndex != 2) {
        videoController.pause();
      } else {
        videoController.play();
      }
    }
    if (currentIndex == 0) {
      final proWatchHomepage =
          Provider.of<HomePageController>(context, listen: false);
      proWatchHomepage.pageController?.jumpToPage(0);
    }
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

  void changeSingleFeildButtonColor({required String value}) {
    if (value.length == 6) {
      singleFieldColored = true;
    } else {
      singleFieldColored = false;
    }

    notifyListeners();
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
    required String url,
    required String name,
  }) {
    isClickedStoryLoading = true;
    tappedStoryIndex = index; // Update tapped story index
    notifyListeners();

    Future.delayed(Duration(seconds: 2)).then((value) {
      isClickedStoryLoading = false;
      tappedStoryIndex = null;
      notifyListeners();

      AppRoutes.push(
          context,
          StoryViewScreen(
            name: name,
            profileUrl: url,
            Profileindex: index,
          ));
    });
  }

  final formKey = GlobalKey<FormState>();
  String selectedUserType = 'Student';
  bool publicUser = false;
  bool collegeStaff = false;
  bool student = false;
  List<String> userTypes = [
    "Student",
    "School/University",
    "Teacher/University professor",
    "Public User"
  ];

  void changeRadio(String value) {
    selectedUserType = value;
    notifyListeners();
  }

  void onDesiginationContinue({
    required BuildContext context,
    required Function() nextPage,
  }) {
    // Reset all variables before setting the selected one
    publicUser = false;
    collegeStaff = false;
    student = false;

    if (selectedUserType == 'Public User') {
      publicUser = true;
      log('Public User selected');
      nextPage();
    } else if (selectedUserType == 'School/University') {
      collegeStaff = true;
      log('School/University selected');
      DesiginationDialog(context);
    } else if (selectedUserType == 'Teacher/University professor') {
      collegeStaff = true;
      log('Teacher/University professor selected');
      nextPage();
    } else if (selectedUserType == 'Student') {
      student = true;
      log('Student selected');
      nextPage();
    }

    notifyListeners(); // Notify UI about changes
  }

  List<String> val = [];

  void changeChip(List<String> selected) {
    val = selected;
    notifyListeners();
  }
}

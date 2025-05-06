import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';

class DropdownController extends ChangeNotifier {
  String? selectedCollegeId;
  String? selectedCollegeName; // Add this to store the college name

  void onChanged(
      {required String collegeId,
      required String collegeName,
      required BuildContext context}) {
    selectedCollegeId = collegeId;
    selectedCollegeName = collegeName; // Store college name

    var url = Uri.parse('${ApiUrls.baseUrl}api/v1/Collage/departments/$selectedCollegeId');
    ApiMethods.get(
      url: url,
      onSucces: (p0) {
        log(p0.body);
      },
      onTokenExpired: () {
        onChanged(
          collegeId: collegeId,
          collegeName: collegeName,
          context: context
        );
      },
      context: context
    );
    notifyListeners();
  }
}

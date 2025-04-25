import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/get_college_list.dart';

class CollegeController extends ChangeNotifier {
  GetCollegeListModel? getCollegeListModel;
  Future<void> getCollege({required BuildContext context}) async {
    await ApiMethods.get(
        url: ApiUrls.getCollegeList,
        onSucces: (p0) {
          getCollegeListModel = getCollegeListModelFromJson(p0.body);
          notifyListeners();
        },
        onTokenExpired: () {
          getCollege(context: context);
        },
        context: context);
  }

  void getDepartments() {}
}

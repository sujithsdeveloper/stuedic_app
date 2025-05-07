import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/searcheduser_model.dart';

class UserSearchController extends ChangeNotifier {
  SearchUserModel? reslust;
  bool isSearchLoading = false;
  List<User> filteredColleges = [];
  Future<void> searchUser(
      {required BuildContext context, required String keyword}) async {
    isSearchLoading = true;
    notifyListeners();
    Map<String, dynamic> data = {"searchTerm": keyword};

    await ApiMethods.post(
        url: ApiUrls.searchApi,
        body: data,
        onSucces: (p0) {
          log(p0.body);
          reslust = searchUserModelFromJson(p0.body);

          // Filter users where isCollege is true
          filteredColleges = (reslust?.response?.users ?? [])
              .where((e) => e.isCollege == true)
              .toList();
          log("Filtered Colleges: ${filteredColleges.toString()}");
          notifyListeners();
        },
        onTokenExpired: () {
          searchUser(context: context, keyword: keyword);
        },
        context: context);
    isSearchLoading = false;
    notifyListeners();
  }
}

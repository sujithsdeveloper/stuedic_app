import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/getuserbyUserId_model.dart';
import 'package:stuedic_app/model/user_current_detail_model.dart';

class ProfileController extends ChangeNotifier {

  UserCurrentDetailsModel? userCurrentDetails;
  Future<void> getCurrentUserData({required BuildContext context}) async {
    await ApiCall.get(
      url: APIs.getUserDetail,
      context: context,
      onSucces: (res) async {
        Logger().f(res.body);
        userCurrentDetails = userCurrentDetailsModelFromJson(res.body);
        log(userCurrentDetails!.response!.followersCount.toString());
        notifyListeners();
      },
      onTokenExpired: () {
        getCurrentUserData(context: context);
      },
    );
  }

  GetUserByUserIdModel? userProfile;
  Future<void> getUserByUserID(
      {required String userId, required BuildContext context}) async {
    await ApiCall.get(
        url: Uri.parse(
            '${APIs.baseUrl}api/v1/Profile/getUserDetails?userId=$userId'),
        onSucces: (p0) {
          // log(p0.body);
          userProfile = getUserByUserIdModelFromJson(p0.body);
          notifyListeners();
          log(userProfile!.response!.followersCount.toString());
        },
        onTokenExpired: () {
          getUserByUserID(userId: userId, context: context);
        },
        context: context);
  }
}

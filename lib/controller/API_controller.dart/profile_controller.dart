import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/APIs/api_services.dart';
import 'package:stuedic_app/model/currentuser_grid_model.dart';
import 'package:stuedic_app/model/getuserbyUserId_model.dart';
import 'package:stuedic_app/model/single_post_model.dart';
import 'package:stuedic_app/model/userGridModel.dart';
import 'package:stuedic_app/model/user_current_detail_model.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:http/http.dart' as http;
import 'package:stuedic_app/utils/refreshTocken.dart';

class ProfileController extends ChangeNotifier {
  UserCurrentDetailsModel? userCurrentDetails;
  Future<void> getCurrentUserData({required BuildContext context}) async {
    await ApiCall.get(
      url: APIs.getUserDetail,
      context: context,
      onSucces: (res) async {
        log("Current user response ${res.body}");
        userCurrentDetails = userCurrentDetailsModelFromJson(res.body);
        AppUtils.saveUserId(userID: userCurrentDetails?.response?.userId ?? '');

        log(userCurrentDetails!.response!.followersCount.toString());
        notifyListeners();
      },
      onTokenExpired: () {
        getCurrentUserData(context: context);
      },
    );
  }

  bool userByUserIdIsloading = false;
  GetUserByUserIdModel? userProfile;
  Future<void> getUserByUserID(
      {required String userId, required BuildContext context}) async {
    userByUserIdIsloading = true;
    notifyListeners();
    await ApiCall.get(
        url: Uri.parse(
            '${APIs.baseUrl}api/v1/Profile/getUserDetails?userId=$userId'),
        onSucces: (p0) {
          log(p0.body);
          userProfile = getUserByUserIdModelFromJson(p0.body);
          userByUserIdIsloading = false;
          notifyListeners();
          log(userProfile!.response!.followersCount.toString());
        },
        onTokenExpired: () {
          userByUserIdIsloading = false;
          notifyListeners();
          getUserByUserID(userId: userId, context: context);
        },
        context: context);
  }

  UserProfileGrid? currentUserProfileGrid;
  Future<void> getCurrentUserGrid({required BuildContext context}) async {
    await ApiCall.get(
        url: APIs.profileGridUrl,
        onSucces: (p0) {
          // log(p0.body);
          currentUserProfileGrid = userProfileGridFromJson(p0.body);
          notifyListeners();
        },
        onTokenExpired: () {
          getCurrentUserGrid(context: context);
        },
        context: context);
  }

  UserGridModel? userGridModel;
  Future<void> getUseGrid(
      {required BuildContext context, required String userID}) async {
    var url = Uri.parse(
        'https://api.stuedic.com/api/v1/Profile/getProfileGrid?userId=$userID');
    await ApiCall.get(
      url: url,
      onSucces: (p0) {
        // log(p0.body);
        userGridModel = userGridModelFromJson(p0.body);
        notifyListeners();
      },
      onTokenExpired: () {
        getUseGrid(context: context, userID: userID);
      },
      context: context,
    );
  }

  SinglePostModel? singlePostModel;
  Future<void> getSinglePost(
      {required BuildContext context, required String postId}) async {
    var url = Uri.parse('${APIs.baseUrl}api/v1/Post/getSinglePost/$postId');
    await ApiCall.get(
        url: url,
        onSucces: (p0) {
          // log(p0.body);
          singlePostModel = singlePostModelFromJson(p0.body);
          notifyListeners();
        },
        onTokenExpired: () {
          getSinglePost(context: context, postId: postId);
        },
        context: context);
  }

  bool isPasswordLoading = false;
  Future<void> changePassword(
      {required String oldPassword,
      required String newPassword,
      required BuildContext context}) async {
    isPasswordLoading = true;
    notifyListeners();
    Map data = {"oldPassword": oldPassword, "password": newPassword};
    var token = await AppUtils.getToken();
    var response = await http.post(APIs.changePassword,
        body: jsonEncode(data),
        headers: ApiServices.getHeadersWithToken(token));

    if (response.statusCode == 200) {
      customSnackbar(label: 'Password Changed Successfully', context: context);
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      await refreshAccessToken(context: context);
    } else if (response.body.contains('Invalid old password')) {
      customSnackbar(label: 'Invalid old Password', context: context);
    } else if (response.body.contains('Password is same as old password')) {
      customSnackbar(
          label: 'Password is same as old password', context: context);
    } else {
      customSnackbar(label: 'Something went wrong', context: context);
    }

    isPasswordLoading = false;
    notifyListeners();
  }
}

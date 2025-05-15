import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
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
  bool? isFollowed;

  Future<void> toggleUser({
    required bool followBool,
    required String userId,
    required BuildContext context,
  }) async {
    log(followBool.toString(), name: '\x1B[32m Before Condition');
    if (followBool) {
      isFollowed = false;
      await unfollowUser(userId: userId, context: context);
      notifyListeners();
      log(followBool.toString(), name: '\x1B[32m after Condition');
    } else {
      isFollowed = true;
      log(followBool.toString(), name: '\x1B[32m Before Condition else');

      await followUser(userId: userId, context: context);
      notifyListeners();
    }
  }

  Future<void> followUser(
      {required String userId, required BuildContext context}) async {
    await ApiMethods.get(
      url: Uri.parse(
          '${ApiUrls.baseUrl}api/v1/Profile/followUser?userId=$userId'),
      onSucces: (p0) {
        Logger().f(p0);
        // context
        //     .read<ProfileController>()
        //     .getUserByUserID(userId: userId, context: context);
        notifyListeners();
      },
      onTokenExpired: () => followUser(userId: userId, context: context),
      context: context,
    );
  }

  Future<void> unfollowUser(
      {required String userId, required BuildContext context}) async {
    await ApiMethods.get(
      url: Uri.parse(
          '${ApiUrls.baseUrl}api/v1/Profile/unfollowUser?userId=$userId'),
      onSucces: (p0) {
        Logger().f(p0);
        // context
        //     .read<ProfileController>()
        //     .getUserByUserID(userId: userId, context: context);

        notifyListeners();
      },
      onTokenExpired: () => unfollowUser(userId: userId, context: context),
      context: context,
    );
  }

  UserCurrentDetailsModel? userCurrentDetails;
  Future<void> getCurrentUserData({required BuildContext context}) async {
    await ApiMethods.get(
      url: ApiUrls.getUserDetail,
      context: context,
      onSucces: (res) async {
        log("Current user response ${res}");
        userCurrentDetails = userCurrentDetailsModelFromJson(res);
        AppUtils.saveCurrentUserDetails(
            userId: userCurrentDetails?.response?.userId ?? '', isUserId: true);
        AppUtils.saveCurrentUserDetails(
            profilePicUrl: userCurrentDetails?.response?.profilePicUrl ?? '',
            isProfilePicurl: true);
        AppUtils.saveCurrentUserDetails(
            userName: userCurrentDetails?.response?.userName ?? '',
            isUserName: true);

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
    log(userId, name: '\x1B[32m profile id');
    notifyListeners();
    await ApiMethods.get(
        url: Uri.parse(
            '${ApiUrls.baseUrl}api/v1/Profile/getUserDetails?userId=$userId'),
        onSucces: (p0) {
          log(p0);
          userProfile = getUserByUserIdModelFromJson(p0);
          userByUserIdIsloading = false;
          notifyListeners();
          // log(userProfile!.response!.followersCount.toString());
        },
        onTokenExpired: () {
          userByUserIdIsloading = false;
          notifyListeners();
          getUserByUserID(userId: userId, context: context);
        },
        context: context);
  }

  UserProfileGrid? currentUserProfileGrid;
  List imageGrid = [];
  List videoGrid = [];
  Future<void> getCurrentUserGrid({required BuildContext context}) async {
    await ApiMethods.get(
        url: ApiUrls.profileGridUrl,
        onSucces: (p0) {
          // log(p0.body);
          currentUserProfileGrid = userProfileGridFromJson(p0);
          //   if (currentUserProfileGrid != null) {
          // if (currentUserProfileGrid.response.posts.map((e) => e.,)) {

          // } else {

          // }

          //   }
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
    await ApiMethods.get(
      url: url,
      onSucces: (p0) {
        // log(p0.body);
        userGridModel = userGridModelFromJson(p0);
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
    var url = Uri.parse('${ApiUrls.baseUrl}api/v1/Post/getSinglePost/$postId');
    await ApiMethods.get(
        url: url,
        onSucces: (p0) {
          // log(p0);
          singlePostModel = singlePostModelFromJson(p0);
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
    var response = await http.post(ApiUrls.changePassword,
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

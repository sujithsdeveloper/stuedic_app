import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/connection_failed_screen.dart';
import 'package:video_player/video_player.dart';

class AppUtils {
////////////////////////////Token Related Functions//////////////////////////////////////////////////////////////////////////////////////
  static Future<String> getToken({bool isRefreshToken = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(isRefreshToken
            ? StringConstants.refreshToken
            : StringConstants.accessToken) ??
        "";
    return token;
  }

  static Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log(prefs.getString(StringConstants.accessToken).toString());
    prefs.remove(StringConstants.accessToken);
    prefs.remove(StringConstants.refreshToken);
    log(prefs.getString(StringConstants.accessToken).toString());
  }

  static Future<void> saveToken(
      {String? refreshToken, String? accessToken}) async {
    final preff = await SharedPreferences.getInstance();
    preff.setString(StringConstants.refreshToken, refreshToken ?? '');
    preff.setString(StringConstants.accessToken, accessToken ?? '');
  }

  static void showToast({required String toastMessage}) {
    Fluttertoast.showToast(
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorConstants.secondaryColor,
        textColor: Colors.white,
        msg: toastMessage);
  }

  /////////////////////////User Related Functions//////////////////////////////////////////////////////////////////////////////////////
  // static Future<void> saveUserId({String? userID}) async {
  //   // log('saveUserId function called with userID: $userID');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(StringConstants.userId, userID ?? '');
  //   // log('User ID saved: ${prefs.getString(StringConstants.userId)}');
  // }


static  String getUserNameById(String? userId){
    if (userId==null || userId.isEmpty) {
      return StringConstants.UnknownUser;
    } else {
      return userId;
      
    }
  }

  static Future<void> saveCurrentUserDetails({
    bool isUserId = false,
    bool isUserName = false,
    bool isProfilePicurl = false,
    String? userId,
    String? userName,
    String? profilePicUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (isUserId) {
      await prefs.setString(StringConstants.userId, userId ?? '');
    }
    if (isUserName) {
      await prefs.setString(StringConstants.userName, userName ?? '');
    }
    if (isProfilePicurl) {
      await prefs.setString(StringConstants.profilePicUrl, profilePicUrl ?? '');
    }
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(StringConstants.userId) ?? "";
    return token;
  }

  static Future<String> getCurrentUserDetails({
    bool isUserId = false,
    bool isUserName = false,
    bool isProfilePicurl = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final profileUrl = prefs.getString(StringConstants.profilePicUrl);

    if (isUserId) {
      return getUserId();
    } else if (isUserName) {
      return getUserName();
    } else if (isProfilePicurl) {
      return profileUrl ?? '';
    } else {
      return prefs.getString(StringConstants.userId) ?? '';
    }
  }

  static Future<bool> checkUserIdForCurrentUser(
      {required String IDtoCheck}) async {
    String? userid = await getUserId();
    // log('Current userId $userid');
    // log('Id to check  $IDtoCheck');
    if (IDtoCheck == userid) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(StringConstants.userName) ?? "";
    return token;
  }

  static Future<bool> checkStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isStudent = prefs.getBool(StringConstants.refreshToken) ?? false;
    return isStudent;
  }

  static Future<void> saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(StringConstants.role, role);
  }

  static Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString(StringConstants.role);
    return role;
  }

  static Future<void> saveForm(
      {required String userName,
      required String collegeName,
      required String deptName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(StringConstants.collageName, collegeName);
    prefs.setString(StringConstants.userName, userName);
    prefs.setString(StringConstants.deptName, deptName);
  }

  static Future<String?> getForm(
      {bool isCollegeName = false, bool isDeptName = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final collegeName = prefs.getString(StringConstants.collageName);
    final userName = prefs.getString(StringConstants.userName);
    final deptName = prefs.getString(StringConstants.deptName);
    if (isCollegeName) {
      return collegeName;
    }
    if (isDeptName) {
      return deptName;
    } else {
      return userName;
    }
  }

  static ImageProvider getProfile({String? url}) {
    if (url == null || url.isEmpty) {
      return AssetImage(ImageConstants.avathar);
    } else {
      return CachedNetworkImageProvider(url);
    }
  }

  static ImageProvider getProfileLocal({File? image}) {
    if (image == null) {
      return AssetImage(ImageConstants.avathar);
    } else {
      return FileImage(image);
    }
  }

///////////////////////////////Math Related Functions//////////////////////////////////////////////////////////////////////////////////////
  static String formatCounts(int count) {
    if (count >= 1000000) {
      return (count % 1000000 == 0)
          ? '${count ~/ 1000000}M'
          : '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return (count % 1000 == 0)
          ? '${count ~/ 1000}K'
          : '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  static String timeAgo(String time) {
    try {
      DateTime dateTime = DateTime.parse(time.replaceAll(' UTC', '')).toLocal();

      Duration diff = DateTime.now().difference(dateTime);

      if (diff.inSeconds < 60) {
        return '${diff.inSeconds}s';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h';
      } else if (diff.inDays < 30) {
        return '${diff.inDays}d';
      } else if (diff.inDays < 365) {
        return '${(diff.inDays / 30).floor()}mo';
      } else {
        return '${(diff.inDays / 365).floor()}y';
      }
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return "Invalid date";
    }
  }

  ////////////////////////local storage related functions//////////////////////////////////////////////////////////////////////////////////////
  static Future<void> saveCredentials(
      {required String email, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(StringConstants.email, email);
    prefs.setString(StringConstants.password, password);
  }

  static Future<String?> getCredentials({required bool getMail}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(StringConstants.email);
    String? password = prefs.getString(StringConstants.password);
    if (getMail) {
      return email;
    } else {
      return password;
    }
  }

  static Future<void> deleteCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(StringConstants.email);
    prefs.remove(StringConstants.password);
    prefs.remove(StringConstants.role);
    prefs.remove(StringConstants.userName);
  }

  static Future<void> saveNotificationConfigure(
      bool isNotificationEnabled) async {
    final preff = await SharedPreferences.getInstance();
    preff.remove(StringConstants.isNotificationEnabled);
    preff.setBool(StringConstants.isNotificationEnabled, isNotificationEnabled);
    log('Notification status: $isNotificationEnabled');
  }

  static Future<bool> getNotificationConfigure() async {
    final preff = await SharedPreferences.getInstance();
    bool isNotificationEnabled =
        preff.getBool(StringConstants.isNotificationEnabled) ?? true;
    log('Notification status: $isNotificationEnabled');
    return isNotificationEnabled;
  }

///////////////////////////////////////Theme Related Functions//////////////////////////////////////////////////////////////////////////////////////
  static bool isDarkTheme(BuildContext context) {
    final theme = Theme.of(context).brightness == Brightness.dark;
    return theme;
  }

  static Future<void> saveTheme(
      {required BuildContext context, required String theme}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(StringConstants.Current_Theme, theme);
  }

  static Future<ThemeMode> getCurrentTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString(StringConstants.Current_Theme);
    if (theme == 'dark') {
      return ThemeMode.dark;
    } else if (theme == 'light') {
      return ThemeMode.light;
    } else {
      return ThemeMode.light;
    }
  }

/////////////////////App Related Functions//////////////////////////////////////////////////////////////////////////////////////
  static Future<bool> checkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      AppRoutes.pushReplacement(context, ConnectionFailedScreen());
      return true;
    }
    return false;
  }

//////////////////////////Media Related Functions//////////////////////////////////////////////////////////////////////////////////////
  static String getFileName(String filePath) {
    return filePath.split('/').last;
  }

  static String getFileExtension(String filePath) {
    return filePath.split('.').last;
  }

  static bool isVideoFile(String filePath) {
    final extension = getFileExtension(filePath);
    return ['mp4', 'mov', 'avi', 'mkv'].contains(extension.toLowerCase());
  }

  static bool isImageFile(String filePath) {
    final extension = getFileExtension(filePath);
    return ['jpg', 'jpeg', 'png', 'gif'].contains(extension.toLowerCase());
  }

  static Future<Duration> getVideoDuration(XFile videoFile) async {
    final videoController = VideoPlayerController.file(File(videoFile.path));
    await videoController.initialize();
    final duration = videoController.value.duration;
    await videoController.dispose();
    return duration;
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';

class AppUtils {
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

  static void showToast({required String msg}) {
    Fluttertoast.showToast(
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorConstants.secondaryColor,
        textColor: Colors.white,
        msg: msg);
  }

  static Future<void> saveUserId({String? userID}) async {
    // log('saveUserId function called with userID: $userID');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(StringConstants.userId, userID ?? '');
    // log('User ID saved: ${prefs.getString(StringConstants.userId)}');
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(StringConstants.userId) ?? "";
    return token;
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

  static ImageProvider getProfile({String? url}) {
    if (url == null || url.isEmpty) {
      return AssetImage(ImageConstants.avathar);
    } else {
      return NetworkImage(url);
    }
  }

  static ImageProvider getProfileLocal({File? image}) {
    if (image == null) {
      return AssetImage(ImageConstants.avathar);
    } else {
      return FileImage(image);
    }
  }

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

  static Future<void> deleteCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(StringConstants.email);
    prefs.remove(StringConstants.password);
    prefs.remove(StringConstants.role);
    prefs.remove(StringConstants.userName);
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

  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}

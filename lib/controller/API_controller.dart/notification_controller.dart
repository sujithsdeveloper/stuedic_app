import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/getNotification_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';

class NotificationController extends ChangeNotifier {
  GetNotification? getNotificationModel;
  bool isLoading = false;
  List<Response> notifications = [];

  Future<void> toggleNotification(bool value) async {
  bool isNotificationEnabled =await AppUtils.getNotificationConfigure() ;

    isNotificationEnabled = value;
    notifyListeners();

    await AppUtils.saveNotificationConfigure(isNotificationEnabled);
  }

  Future<void> getNotification({required BuildContext context}) async {
    var userId = await AppUtils.getUserId();
    isLoading = true;
    notifyListeners();
    await ApiMethods.get(
        url: ApiUrls.getNotification,
        onSucces: (p0) {
          log(p0);
          getNotificationModel = getNotificationFromJson(p0);
          notifications.clear(); // Clear previous notifications
          for (var e in getNotificationModel!.response!) {
            if (e.fromUserId.toString() != userId.toString()) {
              notifications.add(e);
            }
          }
          isLoading = false;
          notifyListeners();
        },
        onTokenExpired: () async {
          await getNotification(context: context);
          isLoading = false;
          notifyListeners();
        },
        context: context);
  }
}

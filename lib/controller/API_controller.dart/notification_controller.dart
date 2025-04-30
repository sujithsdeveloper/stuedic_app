
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/getNotification_model.dart';

class NotificationController extends ChangeNotifier {
  GetNotification? getNotificationModel;
  bool isLoading = false;
  Future<void> getNotification({required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    await ApiMethods.get(
        url: APIs.getNotification,
        onSucces: (p0) {
          // log(p0.body);
          getNotificationModel = getNotificationFromJson(p0.body);
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

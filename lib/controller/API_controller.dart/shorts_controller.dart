import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/get_shorts_model.dart';

class ShortsController extends ChangeNotifier {
  bool isInitialised = false;
  bool isBuffering = true;
  GetShortsModel? getShortsModel;
  Future<void> getReels({required BuildContext context}) async {
    await ApiCall.get(
        url: APIs.reelAPI,
        onSucces: (p0) {
          // log(p0.body);
          getShortsModel = getShortsModelFromJson(p0.body);
          notifyListeners();
        },
        onTokenExpired: () {
          getReels(context: context);
        },
        context: context);
  }



}

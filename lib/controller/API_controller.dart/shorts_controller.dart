import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/get_shorts_model.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';

class ShortsController extends ChangeNotifier {
  bool isInitialised = false;
  bool isBuffering = true;
  GetShortsModel? getShortsModel;

  Future<void> getReels({required BuildContext context}) async {
    try {
      isBuffering = true;
      notifyListeners();
      await ApiMethods.get(
          url: ApiUrls.reelAPI,
          onSucces: (p0) {
            getShortsModel = getShortsModelFromJson(p0);
            isBuffering = false;
            isInitialised = true;
            notifyListeners();
          },
          onTokenExpired: () {
            getReels(context: context);
          },
          context: context);
    } catch (e) {
      isBuffering = false;
      errorSnackbar(label: StringConstants.wrong, context: context);
      notifyListeners();
      debugPrint('Error fetching reels: $e');
    }
  }
}

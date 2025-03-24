import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/disover_model.dart';

class DiscoverController extends ChangeNotifier {
  DiscoverModel? discoverModel;
  Future<void> getDiscoverData(BuildContext context) async {
    await ApiCall.get(
        url: APIs.discover,
        onSucces: (p0) {
          discoverModel = discoverModelFromJson(p0.body);
          notifyListeners();
        },
        onTokenExpired: () async {
          await getDiscoverData(context);
        },
        context: context);
  }
}

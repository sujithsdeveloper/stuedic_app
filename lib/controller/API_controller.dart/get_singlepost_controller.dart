import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/singlepost_model.dart';

class GetSinglepostController extends ChangeNotifier {
  SinglePostModel? singlePostModel;
  bool isLoading = false;
  Future<void> getSinglePost(
      {required BuildContext context, required String postId}) async {
    isLoading = true;
    notifyListeners();
    var url = Uri.parse('${APIs.baseUrl}api/v1/Post/getSinglePost/$postId');
    await ApiCall.get(
        url: url,
        onSucces: (p0) {
          log(p0.body);
          log(postId);
          singlePostModel = singlePostModelFromJson(p0.body);
          isLoading = false;
          notifyListeners();
        },
        onTokenExpired: () async {
          await getSinglePost(context: context, postId: postId);
          isLoading = false;
          notifyListeners();
        },
        context: context);
  }

  void clearData() {
    singlePostModel = null;
    notifyListeners();
  }
}

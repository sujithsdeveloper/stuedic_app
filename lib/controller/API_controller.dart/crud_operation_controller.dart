import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';

class CrudOperationController extends ChangeNotifier {
  void uploadPost(
      {required String imagePath,
      required String caption,
      String visibility = 'Public',
      required BuildContext context}) {
    Map<String, dynamic> data = {
      "postContentURL": imagePath,
      "postDescription": caption,
      "postType": "pic",
      "postVisibility": "public",
      "postColor": "red"
    };

    ApiCall.post(
        url: APIs.addPostUrl,
        body: data,
        onSucces: (p0) {
          Logger().f(p0.body);
        },
        onTokenExpired: () {},
        context: context);
  }

  void deletePost() {}
}

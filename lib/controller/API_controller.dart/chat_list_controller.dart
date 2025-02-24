import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';


class ChatListController extends ChangeNotifier {
  Future<void> getUsersList(context) async {
    await ApiCall.get(
        url: APIs.chatList,
        onSucces: (p0) {
          log(p0.body);
        },
        onTokenExpired: () {
          getUsersList(context);
        },
        context: context);
  }
}

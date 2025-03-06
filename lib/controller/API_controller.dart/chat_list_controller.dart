  import 'dart:developer';

  import 'package:flutter/material.dart';
  import 'package:stuedic_app/APIs/API_call.dart';
  import 'package:stuedic_app/APIs/APIs.dart';
  import 'package:stuedic_app/model/chat_list_users_model.dart.dart';

  class ChatListController extends ChangeNotifier {
    List<ChatListModel> chatList = [];
    bool isListLoading = false;
    Future<void> getUsersList(context) async {
      isListLoading = true;
      notifyListeners();
      await ApiCall.get(
          url: APIs.chatList,
          onSucces: (p0) {
            log(p0.body);
            chatList = chatListModelFromJson(p0.body);
            isListLoading = false;
            notifyListeners();
          },
          onTokenExpired: () {
            getUsersList(context);
          },
          context: context);
      isListLoading = false;
      notifyListeners();
    }
  }

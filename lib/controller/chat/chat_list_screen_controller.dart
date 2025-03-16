import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/chat_list_users_model.dart.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';


class ChatListScreenController with ChangeNotifier {
  bool isLoading = false;
  List<ChatListUsersModel> usersLit = [];

  // get chat history from the server
  Future<void> getUsersList(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final usersListUrl = '${APIs.baseUrl}api/v1/chat/screen';
    log(usersListUrl);
    final token = await AppUtils.getToken();
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    try {
      final res = await http.get(Uri.parse(usersListUrl), headers: headers);

      if (res.statusCode == 200) {
        if (res.body != null && res.body.toLowerCase() != "null") {
          usersLit = chatListUsersModelFromJson(res.body);
          isLoading = false;
        }
      } else {
        isLoading = false;
        notifyListeners();
        errorSnackbar(label: '${res.body}', context: context);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      errorSnackbar(label: e.toString(), context: context);
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}

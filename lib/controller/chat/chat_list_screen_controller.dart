import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/chat_list_users_model.dart.dart';

class ChatListScreenController extends ChangeNotifier {
  List<ChatListUsersModel> usersList = [];
  bool isLoading = false;

  Future<void> getUsersList(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      await ApiMethods.get(
        url: ApiUrls.chatList,
        onSucces: (response) {
          // log(response.body);
          usersList = chatListUsersModelFromJson(response.body);
          isLoading = false;
          notifyListeners();
        },
        onTokenExpired: () {
          log('Token expired, retrying...');
          getUsersList(context);
        },
        context: context,
      );
    } catch (e) {
      log("Error fetching user list: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  final Set<String> _selectedUsersIds = {};
  bool _selectionMode = false;

  bool get isSelectionMode => _selectionMode;
  Set<String> get selectedMessageIds => _selectedUsersIds;

  void toggleSelection(String userId) {
    if (_selectedUsersIds.contains(userId)) {
      _selectedUsersIds.remove(userId);
    } else {
      _selectedUsersIds.add(userId);
    }

    _selectionMode = _selectedUsersIds.isNotEmpty;
    notifyListeners();
  }

  void deleteMessgaes() {}
  void clearSelection() {
    _selectedUsersIds.clear();
    _selectionMode = false;
    notifyListeners();
  }

  Future<void> deleteChats({
    required BuildContext context,
  }) async {
    final data = {"userIDs": selectedMessageIds.toList()};

    ApiMethods.post(
        url: ApiUrls.clearChat,
        body: data,
        onSucces: (p0) {
          notifyListeners();
          log(p0.body);
        },
        onTokenExpired: () {},
        context: context);
  }
}

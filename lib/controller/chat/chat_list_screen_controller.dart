import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/API_Methods.dart';
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
        url: APIs.chatList,
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

  void toggleSelection(String messageId) {
    if (_selectedUsersIds.contains(messageId)) {
      _selectedUsersIds.remove(messageId);
    } else {
      _selectedUsersIds.add(messageId);
    }

    _selectionMode = _selectedUsersIds.isNotEmpty;
    notifyListeners();
  }

  void deleteUsers(BuildContext context) {
    if (_selectedUsersIds.isEmpty) return;
    final userList = _selectedUsersIds
        .map(
          (e) => int.tryParse(e),
        )
        .toList();
    final data = {"userIDs": userList};

    ApiMethods.post(
        body: data,
        url: Uri.parse('${APIs.baseUrl}api/v1/chat/clear'),
        onSucces: (p0) {
          getUsersList(context);
          clearSelection();
        },
        onTokenExpired: () {},
        context: context);

    notifyListeners();
  }

  void clearSelection() {
    _selectedUsersIds.clear();
    _selectionMode = false;
    notifyListeners();
  }
}

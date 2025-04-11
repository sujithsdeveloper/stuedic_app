import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/APIs/websocket_service.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/model/chat_history_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:web_socket_channel/io.dart';
import '../../APIs/API_call.dart';

class ChatController extends ChangeNotifier {
  IOWebSocketChannel? socket;
  List<ChatHistoryModel> chatHistoryList = [];
  ScrollController scrollController = ScrollController();
  bool isHistoryLoading = false;
  Future<void> getChatHistory(
      {required String userId, required BuildContext context}) async {
    isHistoryLoading = true;
    notifyListeners();

    await ApiCall.get(
        url: Uri.parse('${APIs.baseUrl}api/v1/chat/history?toUser=$userId'),
        onSucces: (p0) {
          chatHistoryList = chatHistoryModelFromJson(p0.body);
          isHistoryLoading = false;
          notifyListeners();
          scrollToBottom();
        },
        onTokenExpired: () {
          isHistoryLoading = false;
          notifyListeners();
          getChatHistory(userId: userId, context: context);
        },
        context: context);
    isHistoryLoading = false;
    notifyListeners();
  }

  Future<void> connectToUser({
    required String userId,
  }) async {
    try {
      final token = await AppUtils.getToken();
      final headers = WebsocketService.getHeader(token!);
      socket = await WebsocketService.getSocket(
        url: "wss://api.stuedic.com/api/v1/chat?toUser=$userId",
        headers: headers,
      );
      log('Connected to user: $userId');
      listenToMessages(userId: userId);
    } catch (e) {
      log('Error connecting to user: $e');
    }
  }

  void reconnectSocket({required String userId}) {
    if (socket == null || socket!.closeCode != null) {
      log('Reconnecting to socket...');
      connectToUser(userId: userId);
    }
  }

  void listenToMessages({required String userId}) {
    socket!.stream.listen(
      (data) {
        log('Received message: $data');
        final message = ChatHistoryModel.fromJson(jsonDecode(data));
        chatHistoryList.add(message);

        notifyListeners();
        scrollToBottom();
      },
      onDone: () {
        log('Socket connection closed. Attempting to reconnect...');
        reconnectSocket(userId: userId);
      },
      onError: (error) {
        log('Socket error: $error. Attempting to reconnect...');
        reconnectSocket(userId: userId);
      },
    );
  }

  Future<void> sendMessage(String message, BuildContext context) async {
    if (message.trim().isEmpty) {
      // errorSnackbar(label: "Enter a Proper message", context: context);
    } else {
      log("===> Sending message");
      socket!.sink.add(message.trim());
      int? currentUserId = int.tryParse(await AppUtils.getUserId());
      chatHistoryList.add(
        ChatHistoryModel(
          content: message.trim(),
          timestamp: DateTime.now(),
          fromUserId: currentUserId,
          toUserId: 51484207,
          currentUser: currentUserId,
          read: true,
        ),
      );
      // scrollToBottom();
      notifyListeners();
    }
  }

  void dispose() {
    socket?.sink.close();
    log('Connection Clossed');
    socket = null;
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      }
    });
  }
}

// wss://echo.websocket.org

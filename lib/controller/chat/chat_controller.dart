import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/APIs/websocket_service.dart';
import 'package:stuedic_app/model/chat_history_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:web_socket_channel/io.dart';
import '../../APIs/API_call.dart';

class ChatController extends ChangeNotifier {
  IOWebSocketChannel? socket;
  StreamSubscription? _socketSubscription;
  List<ChatHistoryModel> chatHistoryList = [];
  ScrollController scrollController = ScrollController();
  bool isHistoryLoading = false;
  int numberOfReconnects = 0;
  Future<void> getChatHistory(
      {required String userId, required BuildContext context}) async {
    isHistoryLoading = true;
    notifyListeners();
    // var token = await AppUtils.getToken();
    log('to userid=$userId');
    await ApiCall.get(
        url: Uri.parse('${APIs.baseUrl}api/v1/chat/history?toUser=$userId'),
        onSucces: (response) {
          chatHistoryList = chatHistoryModelFromJson(response.body);
          isHistoryLoading = false;
          notifyListeners();
          scrollToBottom(isScrollVisible: false);
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
        url: "wss://api.stuedic.com/api/v1/chat?toUser=$userId&token=$token",
        headers: headers,
      );
      log('Connected to user: $userId');
      numberOfReconnects = 0;
      listenToMessages(userId: userId);
    } catch (e) {
      log('Error connecting to user: $e');
      reconnectSocket(userId: userId);
    }
  }

  void reconnectSocket({required String userId}) {
    // Only reconnect if socket is null or closed, and limit attempts
    if ((socket == null || socket!.closeCode != null) &&
        numberOfReconnects < 5) {
      numberOfReconnects++;
      log('Reconnecting to socket... attempt $numberOfReconnects');
      connectToUser(userId: userId);
    }
  }

  void listenToMessages({required String userId}) {
    log('listenToMessages called with userId: $userId');
    // Cancel previous subscription if any
    _socketSubscription?.cancel();
    if (socket == null) {
      log('Socket is null. Cannot listen to messages.');
      return;
    }
    _socketSubscription = socket!.stream.listen(
      (data) {
        log('Received message: $data');
        final message = ChatHistoryModel.fromJson(jsonDecode(data));
        chatHistoryList.add(message);
        notifyListeners();
        scrollToBottom(isScrollVisible: true);
      },
      onDone: () {
        log('Socket connection closed. Attempting to reconnect...');
        reconnectSocket(userId: userId);
      },
      onError: (error) {
        log('Socket error: $error. Attempting to reconnect...');
        reconnectSocket(userId: userId);
      },
      cancelOnError: true,
    );
  }

  Future<void> sendMessage(String message, BuildContext context) async {
    if (message.trim().isEmpty) {
      // errorSnackbar(label: "Enter a Proper message", context: context);
      return;
    }
    if (socket == null || socket!.closeCode != null) {
      log("Socket not connected. Attempting to reconnect before sending.");
      // Optionally, you can trigger reconnect here
      // reconnectSocket(userId: ...);
      return;
    }
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
    scrollToBottom(isScrollVisible: true);
    notifyListeners();
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    socket?.sink.close();
    log('Connection Closed');
    socket = null;
    super.dispose();
  }

  void scrollToBottom({required bool isScrollVisible}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final maxScroll = scrollController.position.maxScrollExtent;
        if (isScrollVisible) {
          scrollController.animateTo(
            maxScroll,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
          // Ensure scroll reaches the bottom after possible layout changes
          Future.delayed(const Duration(milliseconds: 100), () {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeIn,
              );
            }
          });
        } else {
          if (scrollController.position.pixels != maxScroll) {
            scrollController.jumpTo(maxScroll);
            // Ensure jump after layout
            // Future.delayed(const Duration(milliseconds: 100), () {
            //   if (scrollController.hasClients) {
            //     scrollController
            //         .jumpTo(scrollController.position.maxScrollExtent);
            //   }
            // });
          }
        }
      }
    });
  }
}

// wss://echo.websocket.org

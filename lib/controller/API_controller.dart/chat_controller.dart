import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/chat_history_model.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/web_socket/websocket_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class ChatController extends ChangeNotifier {
  final ScrollController _scrollController =
      ScrollController(); // Step 1: Create the ScrollController

  bool isLoading = false;
  bool isChatLoading = false;
  late IOWebSocketChannel sendMessageChannel;
  // late IOWebSocketChannel messageHistoryChannel;
  List<ChatHistoryModel> chatHistory = [];

  ScrollController get scrollController =>
      _scrollController; // Step 2: Expose the ScrollController

Future<void> init({required String toUserID, required BuildContext context}) async {
  log("Initializing chat...");
  isLoading = true;
  notifyListeners();

  await connectsenderChannel(toUserID);
  log("Sender channel connected!");

  isLoading = false;
  notifyListeners();

  await getChatHistory(toUserID, context);
  log("Chat history fetched!");

  listenToMessages();
  log("Listening to messages...");
}

// connect to chat socket and stream messagesß
  Future<void> connectsenderChannel(String toUserID) async {
    log("===> Connecting to sender channel");
    final url = '${APIs.socketBaseUrl}api/v1/chat?toUser=$toUserID';
    final headers = WebsocketService.getHeader(await AppUtils.getAccessToken());
    sendMessageChannel =
        await WebsocketService.getSocket(url: url, headers: headers);
  }

//sent message to the socket
  Future<void> sendMessage(String message, BuildContext context) async {
    if (message.trim().isEmpty) {
      // errorSnackbar(label: "Enter a Proper message", context: context);
    } else {
      log("===> Sending message");
      sendMessageChannel.sink.add(message.trim());
      int? currentUserId = int.tryParse(await AppUtils.getUserId());
      chatHistory.add(
        // todo change the fromUserID to the current user id
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

  void listenToMessages() {
    log("===> Listening to received messages");
    sendMessageChannel.stream.listen(
      (data) {
        log("Raw data received: $data"); // Log raw data for debugging
        try {
          final decodedData = jsonDecode(data) as Map<String, dynamic>;
          log("Decoded data: $decodedData");
          final message = ChatHistoryModel.fromJson(decodedData);
          chatHistory.add(message);
          // scrollToBottom();
          notifyListeners(); // Trigger UI update
        } catch (e) {
          log("Error decoding message: $e");
        }
      },
      onError: (error) {
        log("WebSocket error: $error");
      },
      onDone: () {
        log("WebSocket connection closed.");
      },
    );
  }

// get chat history from the server
  Future<void> getChatHistory(String toUserID, BuildContext context) async {
    isChatLoading = true;
    notifyListeners();
    final historyUrl = '${APIs.baseUrl}api/v1/chat/history?toUser=$toUserID';
    log(historyUrl);
    final token = await AppUtils.getAccessToken();
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final res = await http.get(Uri.parse(historyUrl), headers: headers);
      // log("Response Status Code: ${res.statusCode}");
      // log("Response Body: ${res.body}");
      // log("Response Headers: $headers ");

      if (res.statusCode == 200) {
        if (res.body != null) {
          chatHistory = chatHistoryModelFromJson(res.body);
          isChatLoading = false;
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   scrollToBottom(); // Scroll after chat history is loaded
          // });
        }
      } else {
        isChatLoading = false;
        notifyListeners();
        errorSnackbar(label: '${res.body}', context: context);
      }
    } catch (e) {
      isChatLoading = false;
      notifyListeners();
      errorSnackbar(label: e.toString(), context: context);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // void scrollToBottom() {
  //   log("===> Scrolling to the bottom of the list");
  //   // Step 3: Scroll to the bottom of the list when a new message is added
  //   if (_scrollController.hasClients) {
  //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 100);
  //   }
  // }

  @override
  void dispose() {
    sendMessageChannel.sink.close();
    // messageHistoryChannel?.sink.close(status.goingAway);
    super.dispose();
  }
}

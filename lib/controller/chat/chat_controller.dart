import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatController extends ChangeNotifier {
  late WebSocketChannel channel;
  List<String> messages = [];
  bool isConnected = false;

  void initSocket({required String userId}) {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse('${APIs.socketBaseUrl}api/v1/chat?toUser=$userId'),
      );

      isConnected = true;
      notifyListeners();

      channel.stream.listen(
        (message) {
          log("Received message: $message");
          messages.add(message);
          notifyListeners();
        },
        onError: (error) {
          log("WebSocket Error: $error");
          isConnected = false;
          notifyListeners();
        },
        onDone: () {
          log("WebSocket Closed");
          isConnected = false;
          notifyListeners();
        },
      );
    } catch (e) {
      log("Error connecting to WebSocket: $e");
      isConnected = false;
      notifyListeners();
    }
  }

  void sendMessage(String message) {
    if (isConnected) {
      log("Sending message: $message");
      channel.sink.add(message);
    } else {
      log("WebSocket not connected. Cannot send message.");
    }
  }

  @override
  void dispose() {
    log("Closing WebSocket connection...");
    channel.sink.close(status.goingAway);
    super.dispose();
  }
}

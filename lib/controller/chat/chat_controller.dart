import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatController extends ChangeNotifier {
  late WebSocketChannel channel;
  List<String> messages = [];
  bool isConnected = false;
  int _retryCount = 0; // Track the number of retries
  final int _maxRetries = 5; // Maximum number of retries

  void initSocket({required String userId}) {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse('${APIs.socketBaseUrl}api/v1/chat?toUser=$userId'),
      );

      isConnected = true;
      _retryCount = 0; // Reset retry count on successful connection
      notifyListeners();

      channel.stream.listen(
        (message) {
          log("Received message: $message");
          messages.insert(0, message); // Add new messages to the top
          notifyListeners(); // Notify UI to update
        },
        onError: (error) {
          log("WebSocket Error: ${error.toString()}");
          isConnected = false;
          notifyListeners();
          _retryConnection(userId); // Retry connection on error
        },
        onDone: () {
          log("WebSocket Closed");
          isConnected = false;
          notifyListeners();
          _retryConnection(userId); // Retry connection when closed
        },
      );
    } catch (e) {
      log("Error connecting to WebSocket: ${e.toString()}");
      isConnected = false;
      notifyListeners();
      _retryConnection(userId); // Retry connection on exception
    }
  }

  void _retryConnection(String userId) {
    if (_retryCount < _maxRetries) {
      final delay =
          Duration(seconds: 5 * (_retryCount + 1)); // Exponential backoff
      _retryCount++;
      log("Retrying WebSocket connection in ${delay.inSeconds} seconds... (Attempt $_retryCount of $_maxRetries)");
      Future.delayed(delay, () {
        if (!isConnected) {
          initSocket(userId: userId);
        }
      });
    } else {
      log("Max retry attempts reached. WebSocket connection failed.");
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

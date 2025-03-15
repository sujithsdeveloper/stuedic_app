import 'package:flutter/material.dart';
import 'package:stuedic_app/model/chat_history_model.dart';
import 'package:stuedic_app/web_socket/websocket_service.dart';

class ChatController extends ChangeNotifier {
  final WebsocketService _webSocketService = WebsocketService();
  List<ChatHistoryModel> _messages = [];
  
  List<ChatHistoryModel> get messages => _messages;
  bool isChatLoading = true;

  Future<void> init({required String toUserID}) async {
    isChatLoading = true;
    notifyListeners();
    
    // Connect WebSocket
    _webSocketService.connect(toUserID);
    
    // Listen to messages
    _webSocketService.getMessages().listen((message) {
      _messages.add(ChatHistoryModel.fromJson(message)); // Ensure `fromJson` exists in `ChatHistoryModel`
      notifyListeners();
    });

    isChatLoading = false;
    notifyListeners();
  }

  void sendMessage(String message, String fromUserID) {
    _webSocketService.sendMessage({
      'content': message,
      'fromUser': fromUserID,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void disconnect() {
    _webSocketService.disconnect();
  }
}

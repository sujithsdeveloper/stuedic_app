import 'package:stuedic_app/APIs/APIs.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebsocketService {
  WebSocketChannel? _channel;

  void connect(String toUserID) {
    _channel = IOWebSocketChannel.connect('${APIs.socketBaseUrl}api/v1/chat?toUser=$toUserID');
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  Stream<dynamic> getMessages() {
    return _channel?.stream ?? const Stream.empty();
  }

  void disconnect() {
    _channel?.sink.close();
  }
}

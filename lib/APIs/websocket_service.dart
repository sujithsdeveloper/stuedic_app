import 'dart:io';
import 'package:web_socket_channel/io.dart';

class WebsocketService {
  static Map<String, String> getHeader(String token) {
    final headers = {
      'Authorization': 'Bearer $token',
    };
    return headers;
  }

  static Future<IOWebSocketChannel> getSocket({required String url, Map<String, dynamic>? headers}) async {
    final socket = await WebSocket.connect(
      url,
      headers: headers,
    );
    IOWebSocketChannel _channel = IOWebSocketChannel(socket);
    return _channel;
  }
}

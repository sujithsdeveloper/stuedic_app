import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/utils/app_utils.dart';

class ListenToChatlist extends ChangeNotifier {
  Future<void> listenToUserChatList() async {
    log('Listening to chat list...');
    var token = await AppUtils.getToken();
    var url = '${ApiUrls.baseUrl}api/v1/chat/sse?token=$token';

    log('--SUBSCRIBING TO SSE--');
    Stream<SSEModel> client =
        SSEClient.subscribeToSSE(method: SSERequestType.GET, url: url, header: {
      "Accept": "text/event-stream",
      "Connection": "keep-alive",
      "Content-Type": "text/event-stream",
    });
    client.listen((event) {
      log('SSE event received: ${event.toString()}');
    }, onDone: () {
      log('SSE connection closed');
    }, onError: (error) {
      log('SSE error: $error');
    });
  }
}


// listen(
//       (event) {
//         log('SSE event received: ${event.toString()}');
//         if ((event.data != null && event.data!.trim().isNotEmpty) ||
//             (event.event != null && event.event!.trim().isNotEmpty)) {
//           log('Id: ${event.id ?? "null"}');
//           log('Event: ${event.event ?? "null"}');
//           log('Data: ${event.data ?? "null"}');
//         } else {
//           log('SSE event received but data/event is empty');
//         }
//       },
//       onError: (error) {
//         log('SSE error: $error');
//       },
//       onDone: () {
//         log('SSE connection closed');
//       },
//     );
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/API_call.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/model/chat_history_model.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/web_socket/websocket_service.dart';
import 'package:web_socket_channel/io.dart';


class ChatController extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  late IOWebSocketChannel sendMessageChannel;
  List<ChatHistoryModel> chatHistory = [];
  bool isLoading = false;
  bool isChatLoading = false;

  Future<void> init(
      {required String toUserID, required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    await connectsenderChannel(toUserID);
    isLoading = false;
    notifyListeners();

    await getChatHistory(context: context, toUserID: toUserID);
    listenToMessage(context);
  }

  Future<void> sentMessage(
      {required String message, required BuildContext context}) async {
    if (message.isEmpty) {
    } else {
      sendMessageChannel.sink.add(message.trim());
      int? currentUserId = int.tryParse(await AppUtils.getUserId());
      chatHistory.add(ChatHistoryModel(
          content: message,
          timestamp: DateTime.now(),
          fromUserId: currentUserId,
          toUserId: 51484207,
          currentUser: currentUserId,
          read: true));
      notifyListeners();
    }
  }

  Future<void> connectsenderChannel(String toUserID) async {
    log("===> Connecting to sender channel");
    final url = '${APIs.socketBaseUrl}api/v1/chat?toUser=$toUserID';
    final headers = WebsocketService.getHeader(await AppUtils.getAccessToken());
    sendMessageChannel =
        await WebsocketService.getSocket(url: url, headers: headers);
  }

  void listenToMessage(BuildContext context) {
    try {
      sendMessageChannel.stream.listen(
        (event) {
          final message = ChatHistoryModel.fromJson(jsonDecode(event));
          chatHistory.add(message);
          notifyListeners();
        },
      );
    } catch (e) {
      errorSnackbar(label: 'Something went wrong', context: context);
    }
  }

  Future<void> getChatHistory(
      {required String toUserID, required BuildContext context}) async {
    final historyUrl = '${APIs.baseUrl}api/v1/chat/history?toUser=$toUserID';

    await ApiCall.get(
      url: Uri.parse(historyUrl),
      onSucces: (p0) {
        chatHistory = chatHistoryModelFromJson(p0.body);
        notifyListeners();
        log(p0.body);
      },
      onTokenExpired: () {
        log('refresh');
      },
      context: context,
    );
  }

  @override
  void dispose() {
    super.dispose();
    sendMessageChannel.sink.close();
  }
}

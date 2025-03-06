import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/chat_list_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/functions/date_formater.dart';
import 'package:stuedic_app/view/screens/chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ChatListController>().getUsersList(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<ChatListController>();
    final users = prowatch.chatList;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Chats',
            style: StringStyle.appBarText(),
          ),
        ),
        body: Builder(
          builder: (context) {
            if (prowatch.isListLoading) {
              return loadingIndicator();
            } else {
              return ListView.builder(
                cacheExtent: 1000,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final data = users[index];
                  return ListTile(
                    onTap: () {
                      AppRoutes.push(
                          context,
                          ChatScreen(
                              url: '',
                              name: data.username ?? '',
                              userId: data.userId.toString()));
                    },
                    leading: CircleAvatar(
                      backgroundImage:
                          AppUtils.getProfile(url: data.profilePicUrl),
                    ),
                    title: Text(
                      data.username ?? '',
                      style: StringStyle.normalTextBold(),
                    ),
                    subtitle: Text(
                      data.lastMessage ?? 'Tap to sent a message',
                      maxLines: 1,
                    ),
                    trailing: Text(DateFormatter.formatDate(
                        data.timestamp ?? DateTime.now())),
                  );
                },
              );
            }
          },
        ));
  }
}

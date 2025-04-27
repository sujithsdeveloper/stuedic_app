import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/chat/chat_controller.dart';
import 'package:stuedic_app/controller/chat/chat_list_screen_controller.dart';
import 'package:stuedic_app/dialogs/call_alert_dialog.dart';
import 'package:stuedic_app/dialogs/message_delete_alert_dialog.dart';
import 'package:stuedic_app/menu/custom_popup_menu.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/date_formater.dart';
import 'package:stuedic_app/view/screens/chat/call_page.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.userId});

  final String name;
  final String imageUrl;
  final String userId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      log('UserId: ${widget.userId}');
      final currentUserId = await AppUtils.getUserId();
      log('Current UserId: $currentUserId');
      final chatController = context.read<ChatController>();
      chatController.getChatHistory(userId: widget.userId, context: context);
      chatController.connectToUser(userId: widget.userId);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final chatProWatch = context.watch<ChatController>();
    final chatProRead = context.read<ChatController>();

    return WillPopScope(
      onWillPop: () async {
        final chatListController =
            Provider.of<ChatListScreenController>(context, listen: false);
        if (chatProWatch.isSelectionMode) {
          chatProWatch.clearSelection();
          return false;
        } else {
          chatListController.getUsersList(context);
          chatProRead.clearSelection();
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xffF0F0F3),
        appBar: chatProWatch.isSelectionMode
            ? AppBar(
                title: Text(
                  '${chatProWatch.selectedMessageIds.length} selected',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                actions: [
                  IconButton(
                    icon: Icon(CupertinoIcons.delete),
                    onPressed: () {
                      messageDeleteAlertDialog(
                        context: context,
                        onDelete: () {
                          chatProRead.deleteMessgaes(context);
                        },
                      );
                      // chatProWatch.clearSelection();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      chatProWatch.clearSelection();
                    },
                  ),
                ],
              )
            : AppBar(
                title: GestureDetector(
                  onTap: () {
                    AppRoutes.push(context, UserProfile(userId: widget.userId));
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundImage:
                              AppUtils.getProfile(url: widget.imageUrl)),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: StringStyle.normalTextBold(size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        callAlertDialog(
                            callID: '123456',
                            isVoice: false,
                            userId: widget.userId,
                            userName: widget.name,
                            context: context);
                      },
                      icon: const Icon(HugeIcons.strokeRoundedVideo01)),
                  IconButton(
                      onPressed: () {
                        callAlertDialog(
                            context: context,
                            isVoice: true,
                            userId: widget.userId,
                            callID: '123456',
                            userName: widget.name);
                      },
                      icon: const Icon(HugeIcons.strokeRoundedCall)),
                  CustomPopupMenu(items: [
                    PopupMenuItem(
                        onTap: () {
                          AppRoutes.push(
                              context,
                              UserProfile(
                                userId: widget.userId,
                              ));
                        },
                        child: Text('View Profile')),
                    PopupMenuItem(
                        onTap: () {
                          messageDeleteAlertDialog(
                            context: context,
                            onDelete: () async {
                              chatProRead.clearChat(
                                  context: context,
                                  toUserId: int.parse(widget.userId));
                            },
                          );
                        },
                        child: Text('Clear Chat')),
                  ])
                ],
              ),
        body: Builder(
          builder: (context) {
            if (chatProWatch.isHistoryLoading) {
              return loadingIndicator();
            } else if (chatProWatch.chatHistoryList.isEmpty) {
              return const Center(
                child: Text(
                  'No chat history available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            } else {
              return ListView.builder(
                controller: chatProWatch.scrollController,
                itemCount: chatProWatch.chatHistoryList.length,
                itemBuilder: (context, index) {
                  final userId = AppUtils.getUserId();
                  final chatData = chatProWatch.chatHistoryList[index];
                  bool isCurrentUser =
                      chatData.currentUser == chatData.fromUserId;
                  final isSelected =
                      chatProWatch.selectedMessageIds.contains(chatData.id!);

                  return Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: GestureDetector(
                      onLongPress: () {
                        chatProRead.toggleSelection(chatData.id!);
                      },
                      onTap: () {
                        if (chatProWatch.isSelectionMode) {
                          chatProRead.toggleSelection(chatData.id!);
                        }
                      },
                      child: IntrinsicWidth(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth:
                                0, // Let IntrinsicWidth handle min width based on text
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? isSelected
                                        ? Colors.grey.shade500
                                        : Colors.white
                                    : isSelected
                                        ? Colors.grey.shade500
                                        : Color(0xffC2FFC7),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Chat message
                                Text(
                                  chatData.content.toString(),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                const SizedBox(height: 5),
                                // Time text aligned to the right
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    DateFormatter.dateformat_hh_mm_a(
                                        chatData.timestamp ?? DateTime.now()),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        bottomNavigationBar: BottomTextField(
          controller: controller,
          isDarkTheme: isDarkTheme,
          toUserID: int.parse(widget.userId),
        ),
      ),
    );
  }
}

class BottomTextField extends StatelessWidget {
  const BottomTextField(
      {super.key,
      required this.controller,
      required this.isDarkTheme,
      required this.toUserID});

  final TextEditingController controller;
  final bool isDarkTheme;
  final int toUserID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const CircleAvatar(child: Icon(Icons.add)),
          ),
          Expanded(
            child: TextField(
              maxLines: 4,
              minLines: 1,
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Message..',
                hintStyle: TextStyle(
                    color: isDarkTheme ? Colors.grey : Colors.black54),
                filled: true,
                fillColor: isDarkTheme
                    ? const Color(0xff242638)
                    : const Color.fromARGB(255, 78, 80, 94).withOpacity(0.6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              context
                  .read<ChatController>()
                  .sendMessage(controller.text, context, toUserId: toUserID)
                  .then(
                (value) {
                  controller.clear();
                },
              );
            },
            icon: const Icon(
              HugeIcons.strokeRoundedNavigation03,
              size: 30,
              color: ColorConstants.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

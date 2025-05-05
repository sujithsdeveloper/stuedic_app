import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/chat/chat_controller.dart';
import 'package:stuedic_app/controller/chat/chat_list_screen_controller.dart';
import 'package:stuedic_app/dialogs/call_alert_dialog.dart';
import 'package:stuedic_app/dialogs/custom_alert_dialog.dart';
import 'package:stuedic_app/menu/custom_popup_menu.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/date_formater.dart';
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
  late FocusNode messageFocusNode;

  @override
  void initState() {
    super.initState();
    messageFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      log('UserId: ${widget.userId}');
      final currentUserId = await AppUtils.getUserId();
      final chatController = context.read<ChatController>();
      chatController.getChatHistory(userId: widget.userId, context: context);
      chatController.connectToUser(userId: widget.userId);

      // Listen to focus changes
      messageFocusNode.addListener(() {
        chatController.scrollToBottom(isScrollVisible: true);
      });
    });
  }

  @override
  void dispose() {
    messageFocusNode.dispose();
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
        resizeToAvoidBottomInset: true,
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
                      customDialog(
                        context,
                        titile: 'Delete',
                        subtitle:
                            'Are you sure you want to delete the selected message(s)? This action cannot be undone.',
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          CupertinoDialogAction(
                            child: Text('Delete',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              chatProRead.deleteMessgaes(
                                context,
                              );
                              Navigator.pop(context);
                            },
                          ),
                        ],
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
                          customDialog(context,
                              titile: 'Clear Chat',
                              subtitle: 'Are you sure you want to clear chat?',
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                CupertinoDialogAction(
                                  child: Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () {
                                    chatProRead.clearChat(
                                        context: context,
                                        toUserId: int.parse(widget.userId));
                                    Navigator.pop(context);
                                  },
                                ),
                              ]);
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
                  final previousChat = index > 0
                      ? chatProWatch.chatHistoryList[index - 1]
                      : null;
                  final currentTimestamp = chatData.timestamp ?? DateTime.now();
                  final previousTimestamp =
                      previousChat?.timestamp ?? currentTimestamp;
                  final difference =
                      currentTimestamp.difference(previousTimestamp).inMinutes;

// Check if time gap > 5 minutes or if it's the first message
                  final showTimeSeparator = index == 0 || difference > 5;
                  return Column(
                    children: [
                      if (showTimeSeparator)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Text(
                              DateFormatter.dateformat_hh_mm_a(
                                  currentTimestamp),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ),
                      Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onLongPress: () {
                            HapticFeedback.selectionClick();
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
                                minWidth: 0,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8,
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatData.content.toString(),
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        DateFormatter.dateformat_hh_mm_a(
                                            currentTimestamp),
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
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
        bottomNavigationBar: BottomTextField(
          controller: controller,
          focusnode: messageFocusNode,
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
      required this.toUserID,
      required this.focusnode});

  final TextEditingController controller;
  final bool isDarkTheme;
  final int toUserID;
  final FocusNode focusnode;

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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  // context.read<ChatController>().toggleEmojiKeyboard(context);
                },
                icon: const Icon(
                  CupertinoIcons.camera,
                  size: 30,
                  color: ColorConstants.secondaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  // context.read<ChatController>().toggleAttachment(context);
                },
                icon: const Icon(
                  CupertinoIcons.photo_on_rectangle,
                  size: 30,
                  color: ColorConstants.secondaryColor,
                ),
              ),
            ],
          ),
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(30),
              elevation: 3,
              child: TextField(
                focusNode: focusnode,
                keyboardType: TextInputType.multiline,
                enableInteractiveSelection: true,
                // contentInsertionConfiguration: ContentInsertionConfiguration(onContentInserted: (value) => ,),

                maxLines: 4,
                minLines: 1,
                controller: controller,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        context
                            .read<ChatController>()
                            .sendMessage(controller.text, context,
                                toUserId: toUserID)
                            .then(
                          (value) {
                            controller.clear();
                          },
                        );
                      },
                      icon: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Icon(
                          size: 30,
                          Icons.send,
                          color: ColorConstants.primaryColor2,
                        ),
                      )),
                  hintText: 'Message..',
                  hintStyle: TextStyle(
                      color: isDarkTheme ? Colors.grey : Colors.black54),
                  filled: true,
                  fillColor:
                      isDarkTheme ? const Color(0xff242638) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/chat/chat_controller.dart';
import 'package:stuedic_app/controller/chat/chat_list_screen_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/date_formater.dart';
import 'package:stuedic_app/view/screens/chat/call_page.dart';
import 'package:stuedic_app/view/screens/user_profile_screen.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatController = context.read<ChatController>();
      chatController.getChatHistory(userId: widget.userId, context: context);
      chatController.connectToUser(userId: widget.userId);

      // Reconnect socket when the screen is opened
      chatController.reconnectSocket(userId: widget.userId);
    });
  }

  @override
  void dispose() {
    context.read<ChatController>().dispose();
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
        chatListController.getUsersList(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              AppRoutes.push(context, UserProfileScreen(userId: widget.userId));
            },
            child: Row(
              children: [
                CircleAvatar(
                    backgroundImage: AppUtils.getProfile(url: widget.imageUrl)),
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
                  AppRoutes.push(
                      context,
                      CallPage(
                        callID: '345678',
                        userId: widget.userId,
                        username: widget.name,
                      ));
                },
                icon: const Icon(HugeIcons.strokeRoundedVideo01)),
            IconButton(
                onPressed: () {
                  AppRoutes.push(
                      context,
                      CallPage(
                        callID: '345678',
                        isvoice: true,
                        userId: widget.userId,
                        username: widget.name,
                      ));
                },
                icon: const Icon(HugeIcons.strokeRoundedCall)),
            IconButton(
                onPressed: () {},
                icon: const Icon(HugeIcons.strokeRoundedMoreVerticalCircle01)),
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
                  return Align(
                    // alignment: chatData.currentUser == chatData.fromUserId
                    //     ? Alignment.centerLeft
                    //     : Alignment.centerRight,

                    alignment: chatData.currentUser == chatData.fromUserId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                chatData.currentUser == chatData.fromUserId
                                    ? Radius.circular(20)
                                    : Radius.circular(0),
                            topLeft: Radius.circular(20),
                            bottomRight:
                                chatData.currentUser == chatData.fromUserId
                                    ? Radius.circular(0)
                                    : Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Chat message
                            Text(
                              chatData.content.toString(),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            // Time text aligned to the right
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                DateFormatter.dateformat_hh_mm_a_dd_mm_yy(
                                    chatData.timestamp ?? DateTime.now()),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        bottomNavigationBar:
            BottomTextField(controller: controller, isDarkTheme: isDarkTheme),
      ),
    );
  }
}

class BottomTextField extends StatelessWidget {
  const BottomTextField({
    super.key,
    required this.controller,
    required this.isDarkTheme,
  });

  final TextEditingController controller;
  final bool isDarkTheme;

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
                  .sendMessage(controller.text, context);
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

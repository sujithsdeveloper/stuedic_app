import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/chat/chat_controller.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/date_formater.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.url, required this.name, required this.userId});
  final String url;
  final String name;
  final String userId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final chatProRead = context.read<ChatController>();
        await chatProRead.init(toUserID: widget.userId, context: context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatProWatch = context.watch<ChatController>();
    final chatProRead = context.read<ChatController>();
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          title: Row(
            spacing: 9,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.url),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: StringStyle.normalTextBold(),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 3,
                      ),
                      Text(
                        'Active Now',
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
            IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
            // ChatPopupmenuButton(
            //   userId: widget.userId,
            // )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 20),
          child: TextField(
            onChanged: (value) {},
            maxLines: 4,
            minLines: 1,
            controller: controller,
            decoration: InputDecoration(
                hintText: 'Message..',
                hintStyle: TextStyle(
                    color: isDarkTheme ? Colors.grey : Colors.black54),
                filled: true,
                fillColor: isDarkTheme
                    ? Color(0xff242638)
                    : Color.fromARGB(255, 78, 80, 94).withOpacity(0.6),
                suffixIcon: IconButton(
                    onPressed: () {
                      chatProRead.sendMessage(controller.text, context);
                      controller.clear();
                    },
                    icon: Icon(
                      HugeIcons.strokeRoundedNavigation03,
                      size: 30,
                      color: Colors.white,
                    )),
                prefixIcon: IconButton(
                    onPressed: () {
                      // mediaBottomSheet(BottomsheetItems: [
                      //   BottomsheetItems(
                      //       onTap: () {
                      //         // context
                      //         //     .read<PickImageController>()
                      //         //     .pickImage(context: context, source: ImageSource.gallery,API: APIs.uplo);
                      //       },
                      //       label: 'Image',
                      //       iconData: HugeIcons.strokeRoundedImage01),
                      //   BottomsheetItems(
                      //       label: 'Video',
                      //       iconData: HugeIcons.strokeRoundedAiVideo),
                      // ], context: context);
                    },
                    icon: CircleAvatar(
                      child: Icon(Icons.add),
                    )),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ))),
          ),
        ),
        body: chatProWatch.isLoading || chatProWatch.isChatLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: chatProWatch
                    .scrollController, // Step 2: Attach ScrollController
                reverse: true,
                itemCount: chatProWatch.chatHistory.length,
                itemBuilder: (context, index) {
                  final chatData =
                      chatProWatch.chatHistory.reversed.toList()[index];
                  return Align(
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
                          color: ColorConstants.primaryColor,
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
              ));
  }
}

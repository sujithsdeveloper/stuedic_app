import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/chat/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.userId,
  });

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
    context.read<ChatController>().initSocket(userId: widget.userId);
  }

  @override
  void dispose() {
    context.read<ChatController>().dispose(); // Ensure WebSocket is closed
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final chatProWatch = context.watch<ChatController>();
    final chatProRead = context.read<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl),
            ),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(HugeIcons.strokeRoundedVideo01)),
          IconButton(
              onPressed: () {}, icon: const Icon(HugeIcons.strokeRoundedCall)),
          IconButton(
              onPressed: () {},
              icon: const Icon(HugeIcons.strokeRoundedMoreVerticalCircle01)),
        ],
      ),
      bottomNavigationBar: Padding(
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
                if (controller.text.isNotEmpty) {
                  chatProWatch.sendMessage(controller.text);
                  controller.clear();
                }
              },
              icon: const Icon(
                HugeIcons.strokeRoundedNavigation03,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (!chatProWatch.isConnected)
            Container(
              color: Colors.redAccent,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "Disconnected. Retrying...",
                style: TextStyle(color: Colors.white),
              ),
            ),
          Expanded(
            child: Consumer<ChatController>(
              builder: (context, chatPro, child) {
                return chatPro.messages.isEmpty
                    ? const Center(child: Text("No messages yet"))
                    : ListView.builder(
                        reverse: true, // Show the latest messages at the bottom
                        itemCount: chatPro.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatPro.messages[index];
                          final isSentByUser = index % 2 == 0; // Example logic
                          return Align(
                            alignment: isSentByUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSentByUser
                                    ? Colors.blueAccent
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message,
                                style: TextStyle(
                                    color: isSentByUser
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

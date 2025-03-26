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
    final chatProRead = context.read<ChatController>();
    chatProRead.initSocket(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final chatProWatch = context.watch<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
        child: TextField(
          maxLines: 4,
          minLines: 1,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Message..',
            hintStyle:
                TextStyle(color: isDarkTheme ? Colors.grey : Colors.black54),
            filled: true,
            fillColor: isDarkTheme
                ? const Color(0xff242638)
                : const Color.fromARGB(255, 78, 80, 94).withOpacity(0.6),
            suffixIcon: IconButton(
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
            prefixIcon: IconButton(
              onPressed: () {},
              icon: const CircleAvatar(child: Icon(Icons.add)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: Consumer<ChatController>(
        builder: (context, chatPro, child) {
          return chatPro.messages.isEmpty
              ? const Center(child: Text("No messages yet"))
              : ListView.builder(
                  itemCount: chatPro.messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(chatPro.messages[index]),
                    );
                  },
                );
        },
      ),
    );
  }
}

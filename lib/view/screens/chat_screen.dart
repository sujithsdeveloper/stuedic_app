import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/chat_controller.dart';
import 'package:stuedic_app/utils/functions/date_formater.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.url,
    required this.name,
    required this.userId,
  });

  final String url;
  final String name;
  final String userId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<ChatController>().init(toUserID: widget.userId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProWatch = context.watch<ChatController>();
    final chatProRead = context.read<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.url),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 3,
                    ),
                    SizedBox(width: 5),
                    Text('Active Now', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
        ],
      ),
      body: chatProWatch.isChatLoading
          ? const Center(child: CircularProgressIndicator())
          : chatProWatch.messages.isEmpty
              ? const Center(child: Text('No messages found'))
              : ListView.builder(
                  reverse: true,
                  itemCount: chatProWatch.messages.length,
                  itemBuilder: (context, index) {
                    final chatData =
                        chatProWatch.messages.reversed.toList()[index];

                    return Align(
                      alignment: chatData.currentUser == chatData.fromUserId
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[700],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chatData.content.toString(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                DateFormatter.dateformat_hh_mm_a_dd_mm_yy(
                                  chatData.timestamp ?? DateTime.now(),
                                ),
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar:
          ChatTextField(controller: controller, chatProRead: chatProRead),
    );
  }
}

class ChatTextField extends StatelessWidget {
  const ChatTextField(
      {super.key, required this.controller, required this.chatProRead});

  final TextEditingController controller;
  final ChatController chatProRead;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: TextField(
        controller: controller,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Message...',
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: IconButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                chatProRead.sendMessage(controller.text.trim(), 'yourUserID');
                controller.clear();
              }
            },
            icon: const Icon(Icons.send, size: 24),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

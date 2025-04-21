import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/chat/chat_controller.dart';
import 'package:stuedic_app/controller/chat/chat_list_screen_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/functions/date_formater.dart';
import 'package:stuedic_app/view/screens/chat/chat_screen.dart';
import 'package:stuedic_app/view/screens/search_screen.dart';
import 'package:stuedic_app/widgets/gradient_container.dart';
import 'package:stuedic_app/widgets/refresh_indicator_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    log('ChatListScreen initState called');
    final chatProRead =
        Provider.of<ChatListScreenController>(context, listen: false);
    chatProRead.getUsersList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatProWatch = context.watch<ChatListScreenController>();
    final chatList = chatProWatch.usersList;
    final chatProRead = context.read<ChatListScreenController>();

    debugPrint("User list length: ${chatProWatch.usersList.length}");

    return WillPopScope(
      onWillPop: () async {
        widget.controller.previousPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              widget.controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            },
            icon: Builder(
              builder: (context) {
                if (Platform.isIOS) {
                  return Icon(
                    CupertinoIcons.back,
                  );
                } else {
                  return Icon(
                    Icons.arrow_back,
                  );
                }
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 9),
              child: CircleAvatar(
                backgroundColor: ColorConstants.greyColor,
                child: IconButton(
                  onPressed: () {
                    AppRoutes.push(context, const SearchScreen());
                  },
                  icon: const Icon(CupertinoIcons.search),
                ),
              ),
            )
          ],
          title: Row(
            children: [
              GradientContainer(height: 23, width: 9, verticalGradient: true),
              const SizedBox(width: 9),
              Text(StringConstants.appName,
                  style: StringStyle.appBarText(context: context)),
            ],
          ),
        ),
        body: chatProWatch.isLoading
            ? loadingIndicator()
            : chatProWatch.usersList.isEmpty
                ? const Center(child: Text("No users found"))
                : customRefreshIndicator(
                    onRefresh: () async {
                      chatProRead.getUsersList(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Builder(builder: (context) {
                        if (chatList == null || chatList.isEmpty) {
                          return Column(
                            children: [
                              Image.asset(
                                ImageConstants.no_message_list_found,
                                height: 189,
                                width: 189,
                              ),
                              Text(
                                'No Messages',
                                style: StringStyle.normalTextBold(),
                              )
                            ],
                          );
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: chatProWatch.usersList.length,
                                  itemBuilder: (context, index) {
                                    if (index >=
                                        chatProWatch.usersList.length) {
                                      return const SizedBox();
                                    }

                                    final user = chatProWatch.usersList[index];
                                    final time = AppUtils.timeAgo(
                                        user?.timestamp.toString() ??
                                            DateTime.now().toString());

                                    return ListTile(
                                      onLongPress: () {},
                                      minTileHeight: 60,
                                      onTap: () {
                                        AppRoutes.push(
                                          context,
                                          ChangeNotifierProvider(
                                            create: (context) =>
                                                ChatController(),
                                            child: ChatScreen(
                                              name: user.username.toString(),
                                              userId: user.userId.toString(),
                                              imageUrl:
                                                  user.profilePicUrl.toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: AppUtils.getProfile(
                                            url: user.profilePicUrl),
                                      ),
                                      title: Text(
                                        user.username ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        user.lastMessage.toString(),
                                        style: TextStyle(
                                            color:
                                                ColorConstants.secondaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        time,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 9),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                    ),
                  ),
      ),
    );
  }
}

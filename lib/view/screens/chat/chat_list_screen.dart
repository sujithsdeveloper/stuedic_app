import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/chat/chat_controller.dart';
import 'package:stuedic_app/controller/chat/chat_list_screen_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/functions/date_formater.dart';
import 'package:stuedic_app/view/screens/chat/chat_screen.dart';
import 'package:stuedic_app/view/screens/search_screen.dart';
import 'package:stuedic_app/widgets/gradient_container.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final chatProRead = context.read<ChatListScreenController>();
        chatProRead.getUsersList(context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final chatProWatch = context.watch<ChatListScreenController>();
    // bool isDark = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        widget.controller.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            widget.controller.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInCubic);
          }, icon: Builder(
            builder: (context) {
              if (Platform.isAndroid) {
                return Icon(Icons.arrow_back);
              } else if (Platform.isIOS) {
                return Icon(CupertinoIcons.back);
              } else {
                return SizedBox();
              }
            },
          )),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 9),
              child: CircleAvatar(
                backgroundColor: ColorConstants.greyColor,
                child: IconButton(
                    onPressed: () {
                      AppRoutes.push(context, SearchScreen());
                    },
                    icon: Icon(CupertinoIcons.search)),
              ),
            )
          ],
          title: Row(
            children: [
              GradientContainer(height: 23, width: 9, verticalGradient: true),
              const SizedBox(width: 9),
              Text(StringConstants.appName, style: StringStyle.appBarText()),
            ],
          ),
        ),
        body: chatProWatch.isLoading
            ? loadingIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: chatProWatch.usersLit.length,
                        itemBuilder: (context, index) {
                          final user = chatProWatch.usersLit[index];
                          return ListTile(
                            minTileHeight: 60,
                            onTap: () {
                              AppRoutes.push(
                                  context,
                                  ChangeNotifierProvider(
                                      create: (context) => ChatController(),
                                      child: ChatScreen(
                                          name: user.username.toString(),
                                          userId: user.userId.toString(),
                                          url: user.profilePicUrl.toString())));
                            },
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(user.profilePicUrl ?? ""),
                            ),
                            title: Text(
                              user.username.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              user.lastMessage.toString(),
                              style: TextStyle(color: Color(0xff2097d5)),
                            ),
                            trailing: Text(
                              DateFormatter.formatDate(
                                  user.timestamp ?? DateTime.now()),
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

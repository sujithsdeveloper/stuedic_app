import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/chat/chat_list_screen_controller.dart';
import 'package:stuedic_app/controller/chat/listen_to_chatList.dart';
import 'package:stuedic_app/dialogs/custom_alert_dialog.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
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
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final chatProRead =
            Provider.of<ChatListScreenController>(context, listen: false);
        final provider = Provider.of<ListenToChatlist>(context, listen: false);
        chatProRead.getUsersList(context);
        provider.listenToUserChatList();
      },
    );
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
        if (chatProWatch.isSelectionMode) {
          chatProWatch.clearSelection();
          return false;
        }
        widget.controller.previousPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        return false;
      },
      child: Scaffold(
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
                      // chatProWatch.clearSelection();
                      customDialog(context,
                          titile: 'Delete User',
                          subtitle:
                              'Are you sure you want to delete the selected message(s)? This action cannot be undone.',
                          actions: [
                            CupertinoDialogAction(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                chatProRead.deleteUsers(context);
                                Navigator.pop(context);
                              },
                            ),
                          ]);
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
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 9),
                  //   child: CircleAvatar(
                  //     backgroundColor: ColorConstants.greyColor,
                  //     child: IconButton(
                  //       onPressed: () {
                  //         AppRoutes.push(context, const SearchScreen());
                  //       },
                  //       icon: const Icon(CupertinoIcons.search),
                  //     ),
                  //   ),
                  // )
                ],
                title: Row(
                  children: [
                    GradientContainer(
                        height: 23, width: 9, verticalGradient: true),
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    AppRoutes.push(
                                        context, SearchScreen(toChat: true));
                                  },
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20),
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(CupertinoIcons.search),
                                          SizedBox(width: 10),
                                          Text('Search...',
                                              style:
                                                  StringStyle.normalTextBold()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: chatProWatch.usersList.length,
                                itemBuilder: (context, index) {
                                  if (index >= chatProWatch.usersList.length) {
                                    return const SizedBox();
                                  }

                                  final user = chatProWatch.usersList[index];
                                  final time = AppUtils.timeAgo(
                                      user?.timestamp.toString() ??
                                          DateTime.now().toString());
                                  final isSelected = chatProWatch
                                      .selectedMessageIds
                                      .contains(user.userId.toString()!);

                                  return GestureDetector(
                                    onLongPress: () {
                                      HapticFeedback.selectionClick();
                                      chatProRead.toggleSelection(
                                          user.userId.toString()!);
                                    },
                                    onTap: () {
                                      if (chatProWatch.isSelectionMode) {
                                        chatProRead.toggleSelection(
                                            user.userId.toString()!);
                                      } else {
                                        chatProRead.clearSelection();
                                        AppRoutes.push(
                                            context,
                                            ChatScreen(
                                              userId: user.userId.toString(),
                                              name: user.username ?? '',
                                              imageUrl:
                                                  user.profilePicUrl ?? '',
                                            ));
                                      }
                                    },
                                    child: Material(
                                      color: isSelected
                                          ? Colors.grey.shade500
                                          : Colors.transparent,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ListTile(
                                          minTileHeight: 60,
                                          leading: CircleAvatar(
                                              radius: 25,
                                              backgroundImage:
                                                  AppUtils.getProfile(
                                                      url: user.profilePicUrl)),
                                          title: Text(
                                            user.username ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            user.lastMessage.toString(),
                                            style: TextStyle(
                                                color: ColorConstants
                                                    .secondaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Column(
                                            children: [
                                              Text(time,
                                                  style: const TextStyle(
                                                      color: Colors.grey)),
                                              Container(
                                                height: 22,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff40C4FF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Center(
                                                  child: Text(
                                                    '5',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
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
    );
  }
}

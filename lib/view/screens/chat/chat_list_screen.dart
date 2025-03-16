import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/chat/chat_controller.dart';
import 'package:stuedic_app/controller/chat/chat_list_screen_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/functions/date_formater.dart';
import 'package:stuedic_app/view/screens/chat/chat_screen.dart';
import 'package:stuedic_app/view/screens/search_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
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
    final chatProWatch = context.watch<ChatListScreenController>();
    // bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chats',
        ),
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       final preff = await SharedPreferences.getInstance();
          //       final token = preff.getString('refreshToken');

          //       try {
          //         var response = await http.post(
          //           APIs.logoutUser,
          //           headers: {
          //             "Content-Type": "application/json",
          //             "Authorization": "Bearer $token",
          //           },
          //         );

          //         if (response.statusCode == 200) {
          //           preff.remove('token');
          //           preff.remove('refreshToken');
          //           Navigator.pushAndRemoveUntil(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => LoginScreen(),
          //             ),
          //             (route) => false,
          //           );
          //         } else {
          //           log(response.body);
          //         }
          //       } catch (e) {
          //         errorSnackbar(label: e.toString(), context: context);
          //       }
          //     },
          //     icon: Icon(Icons.logout))

          // Padding(
          //   padding: const EdgeInsets.only(right: 9),
          //   child: CircleAvatar(
          //     backgroundColor: Color(0xff2097d5),
          //     child: Icon(Icons.settings),
          //   ),
          // ),
        ],
      ),
      body: chatProWatch.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(

toChat: true,                                ),
                              ));
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Who do you want to chat with?',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Icon(Icons.search)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 5),
                            child: Text('Active'),
                          ),
                          SizedBox(height: 9),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: List.generate(
                                3,
                                (index) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  height: 100,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffe9f5fa)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 9,
                                      ),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                           ''),
                                      ),
                                      Text('dfghjk')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                       AppRoutes.push(context, ChangeNotifierProvider(
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
    );
  }
}

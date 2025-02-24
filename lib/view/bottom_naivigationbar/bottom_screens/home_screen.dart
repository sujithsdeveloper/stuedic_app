import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:stuedic_app/elements/postCard.dart';
import 'package:stuedic_app/elements/story_section.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/screens/chat_list_screen.dart';
import 'package:stuedic_app/view/screens/notification_default_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                StringConstants.appName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'latoRegular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    HugeIcons.strokeRoundedNotification01,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    AppRoutes.push(context, NotificationDefaultScreen());
                  },
                ),
                IconButton(
                  icon: Icon(
                    HugeIcons.strokeRoundedMessage01,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    AppRoutes.push(context, ChatListScreen());
                  },
                ),
              ]),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: StorySection(),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => PostCard(
                index: index,
                imageUrl: items[index]['imageUrl'],
                name: items[index]['username'],
                profileUrl: items[index]['profileUrl'],
                caption: items[index]['caption'],
              ),
              childCount: items.length, // Example count
            ),
          ),
        ],
      ),
    );
  }
}

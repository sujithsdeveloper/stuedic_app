import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/search_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/functions/shimmer/shimmers_items.dart';
import 'package:stuedic_app/view/screens/chat/chat_screen.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.toChat = false});
  final bool toChat;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<UserSearchController>();
    final proRead = context.read<UserSearchController>();
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: controller,
            onChanged: (value) {
              if (value != null && value.isNotEmpty) {
                proRead.searchUser(context: context, keyword: value);
              }
              if (value == null || value.isEmpty) {
                proRead.reslust = null;
                proRead.notifyListeners();
              }
            },
            autofocus: true,
            decoration: InputDecoration(
                filled: true,
                hintText: "Search",
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(99),
                )),
          ),
        ),
        body: Builder(
          builder: (context) {
            final users = prowatch.reslust?.response!.users;
            if (prowatch.isSearchLoading) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return searchShimmer();
                },
              );
            } else if (prowatch.reslust?.response?.users == null &&
                controller.text.isNotEmpty) {
              return Center(
                child: Text('No user found'),
              );
            } else if (users?.isNotEmpty ?? true) {
              return ListView.builder(
                  itemCount: prowatch.reslust?.response?.users?.length ?? 0,
                  itemBuilder: (context, index) {
                    final user = prowatch.reslust?.response?.users?[index];
                    return ListTile(
                      onTap: () {
                        if (widget.toChat) {
                          AppRoutes.push(
                              context,
                              ChatScreen(
                                  imageUrl: user?.profilePicUrl ?? '',
                                  name: user?.username ?? '',
                                  userId: user?.userId ?? ''));
                        } else {
                          AppRoutes.push(
                              context, UserProfile(userId: user?.userId ?? ''));
                        }
                      },
                      leading: CircleAvatar(
                        backgroundImage: AppUtils.getProfile(
                            url: user?.profilePicUrl ?? null),
                      ),
                      title: Text(
                        user?.username ?? '',
                        style: StringStyle.normalTextBold(),
                      ),
                      subtitle: Text(user?.userId ?? ''),
                    );
                  });
            } else {
              return SizedBox();
            }
          },
        ));
  }
}

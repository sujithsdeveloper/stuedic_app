import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/search_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/loading_style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/view/screens/chat/chat_screen.dart';
import 'package:stuedic_app/view/screens/user_profile_screen.dart';

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
            proRead.searchUser(context: context, keyword: value);
          },
          autofocus: true,
          decoration: InputDecoration(
              filled: true,
              hintText: "Search",
              prefixIcon: Icon(CupertinoIcons.search),
              fillColor: ColorConstants.greyColor,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(99),
              )),
        ),
      ),
      body: ListView.builder(
          itemCount: prowatch.reslust?.response?.users?.length ?? 0,
          itemBuilder: (context, index) {
            final users = prowatch.reslust?.response!.users;
            final user = prowatch.reslust?.response!.users?[index];
            if (prowatch.isSearchLoading) {
              return loadingIndicator();
            } else if (users?.isEmpty ?? true) {
              return SizedBox();
            } else if (users?.isNotEmpty ?? true) {
              return ListTile(
                onTap: () {
                  if (widget.toChat) {
                    AppRoutes.push(
                        context,
                        ChatScreen(
                            url: user?.profilePicUrl ?? '',
                            name: user?.username ?? '',
                            userId: user?.userId ?? ''));
                  } else {
                    AppRoutes.push(
                        context, UserProfileScreen(userId: user?.userId ?? ''));
                  }
                },
                leading: CircleAvatar(
                  backgroundImage:
                      AppUtils.getProfile(url: user?.profilePicUrl ?? null),
                ),
                title: Text(
                  user?.username ?? '',
                  style: StringStyle.normalTextBold(),
                ),
                subtitle: Text(user?.userId ?? ''),
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }
}

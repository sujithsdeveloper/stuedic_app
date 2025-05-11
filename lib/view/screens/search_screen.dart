import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/search_controller.dart';
import 'package:stuedic_app/model/searcheduser_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/shimmer/shimmers_items.dart';
import 'package:stuedic_app/view/screens/chat/chat_screen.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.toChat = false});
  final bool toChat;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

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
          bottom: controller.text.isEmpty
              ? null
              : TabBar(
                  enableFeedback: true,
                  splashFactory: NoSplash.splashFactory,
                  dividerColor: Colors.transparent,
                  indicatorColor: ColorConstants.secondaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: tabController,
                  tabAlignment: TabAlignment.fill,
                  labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.secondaryColor),
                  tabs: [
                      Tab(text: "Top"),
                      Tab(text: "Colleges"),
                      Tab(text: "Students"),
                      Tab(text: "Marketplace"),
                    ]),
        ),
        body: Builder(
          builder: (context) {
            if (controller.text.isEmpty) {
              return Center(
                child: Text('Search for users'),
              );
            } else if (prowatch.reslust == null && controller.text.isEmpty) {
              return Center(
                child: Text(
                  'Search Users',
                  style: StringStyle.normalTextBold(size: 18),
                ),
              );
            } else {
              return TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  TopBar(
                    toChat: widget.toChat,
                    controller: controller,
                  ),
                  GeFilterdtSearchResult(
                    isCollege: true,
                    controller: controller,
                    toChat: widget.toChat,
                  ),
                  GeFilterdtSearchResult(
                    onlyStudents: true,
                    controller: controller,
                    toChat: widget.toChat,
                  ),
                  MarketPlaceView(),
                ],
              );
            }
          },
        ));
  }

  // Modified getSearchResult to support filtering for colleges and students
}

///////////////////MarketPlaceView////////////////////////////////////////Market place///////////////////////////////////////////////////////////////////////////
class MarketPlaceView extends StatelessWidget {
  const MarketPlaceView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Marketplace is not available yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/////////////////////////UserSearchResult///////////////////////////////////////User Search Result///////////////////////////////////////////////////////////////////////////
/// This widget displays the search results for users based on the search term entered in the TextField.
class GeFilterdtSearchResult extends StatelessWidget {
  const GeFilterdtSearchResult(
      {this.isCollege = false,
      this.onlyStudents = false,
      required this.controller,
      required this.toChat});

  final bool isCollege;
  final bool onlyStudents;
  final TextEditingController controller;
  final bool toChat;

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<UserSearchController>();

    List<User>? users;
    if (isCollege) {
      users = prowatch.filteredColleges;
    } else if (onlyStudents) {
      users = (prowatch.reslust?.response?.users ?? [])
          .where((e) => e.isCollege != true)
          .toList();
    } else {
      users = prowatch.reslust?.response?.users;
    }

    return Builder(
      builder: (context) {
        if (prowatch.isSearchLoading) {
          return ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return searchShimmer();
            },
          );
        } else if ((users == null || users.isEmpty) &&
            controller.text.isNotEmpty) {
          return Center(
            child: Text('No user found'),
          );
        } else if (users != null && users.isNotEmpty) {
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users![index];
                return ListTile(
                  onTap: () {
                    if (toChat) {
                      AppRoutes.push(
                          context,
                          ChatScreen(
                              imageUrl: user.profilePicUrl ?? '',
                              name: user.username ?? '',
                              userId: user.userId ?? ''));
                    } else {
                      log('isCOllege: ${user.isCollege}');
                      AppRoutes.push(
                          context, UserProfile(userId: user.userId ?? ''));
                    }
                  },
                  leading: CircleAvatar(
                    backgroundImage:
                        AppUtils.getProfile(url: user.profilePicUrl ?? null),
                  ),
                  title: Text(
                    user.username ?? '',
                    style: StringStyle.normalTextBold(),
                  ),
                  subtitle: Text(user.userId ?? ''),
                );
              });
        } else {
          return SizedBox();
        }
      },
    );
  }
}

///////////////TopBar///////////////////////////////////////TopBar///////////////////////////////////////////////////////////////////////////
/// This widget displays a grid of items in the top bar of the search screen.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.toChat,
    required this.controller,
  });
  final bool toChat;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<UserSearchController>();
    final users = prowatch.reslust?.response?.users;

    return Builder(
      builder: (context) {
        if (prowatch.isSearchLoading) {
          return ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return searchShimmer();
            },
          );
        } else if ((users == null || users.isEmpty) &&
            controller.text.isNotEmpty) {
          return Center(
            child: Text('No user found'),
          );
        } else if (users != null && users.isNotEmpty) {
          return ListView.builder(
              itemCount: users?.length ?? 0,
              itemBuilder: (context, index) {
                final user = users![index];
                return ListTile(
                  onTap: () {
                    if (toChat) {
                      AppRoutes.push(
                          context,
                          ChatScreen(
                              imageUrl: user.profilePicUrl ?? '',
                              name: user.username ?? '',
                              userId: user.userId ?? ''));
                    } else {
                      log('isCOllege: ${user.isCollege}');
                      AppRoutes.push(
                          context, UserProfile(userId: user.userId ?? ''));
                    }
                  },
                  leading: CircleAvatar(
                    backgroundImage:
                        AppUtils.getProfile(url: user.profilePicUrl ?? null),
                  ),
                  title: Text(
                    user.username ?? '',
                    style: StringStyle.normalTextBold(),
                  ),
                  subtitle: Text(user.userId ?? ''),
                );
              });
        } else {
          return SizedBox();
        }
      },
    );
  }
}

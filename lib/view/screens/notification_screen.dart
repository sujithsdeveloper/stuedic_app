import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/notification_controller.dart';
import 'package:stuedic_app/model/getNotification_model.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/functions/shimmers_items.dart';
import 'package:stuedic_app/view/screens/singlepost_screen.dart';
import 'package:stuedic_app/view/screens/user_profile_screen.dart';
import 'package:stuedic_app/widgets/custom_list_tile.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';
import 'package:stuedic_app/widgets/refresh_indicator_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationController>().getNotification(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final proWatch = context.watch<NotificationController>();
    final proRead = context.read<NotificationController>();
    final notifications =
        proWatch.getNotificationModel?.response?.toList().reversed.toList();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Notification',
            style: StringStyle.normalTextBold(),
          ),
          centerTitle: true,
        ),
        body: customRefreshIndicator(
          onRefresh: () async {
            await proRead.getNotification(context: context);
          },
          child: Builder(
            builder: (context) {
              if (proWatch.isLoading) {
                return ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ShimmersItems.notificationShimmer();
                  },
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Recent",
                        style: StringStyle.normalTextBold(),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: notifications?.length ?? 0,
                        itemBuilder: (context, index) {
                          final notification = notifications?[index];
                          final time = AppUtils.timeAgo(
                              notification?.created ?? DateTime.now());
                          return CustomListTile(
                            onTap: () {
                              AppRoutes.push(
                                  context,
                                  SinglepostScreen(
                                      postID: notification?.postId.toString() ??
                                          ''));
                            },
                            leading: LeadingAvathar(
                              notification: notification,
                              onTap: () {
                                AppRoutes.push(
                                    context,
                                    UserProfileScreen(
                                        userId: notification?.fromUserId
                                                .toString() ??
                                            ''));
                              },
                            ),
                            title: GestureDetector(
                              onTap: () {
                                AppRoutes.push(
                                    context,
                                    UserProfileScreen(
                                        userId: notification?.fromUserId
                                                .toString() ??
                                            ''));
                              },
                              child: Text(
                                notification?.fromUserName ?? '',
                                style: StringStyle.normalTextBold(),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (notification!.type ==
                                        StringConstants.like) {
                                      return Text(
                                          '${notification.fromUserName}Liked your post');
                                    } else {
                                      return Text(
                                          '${notification.fromUserName} Commented on your post');
                                    }
                                  },
                                ),
                                Text('$time ago')
                              ],
                            ),
                            trailing: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          notification?.postContentUrl ?? ''))),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ));
  }
}

class LeadingAvathar extends StatelessWidget {
  const LeadingAvathar({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final Response? notification;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                AppUtils.getProfile(url: notification?.fromUserPicUrl ?? ''),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: GradientCircleAvathar(
                radius: 20,
                child: Builder(
                  builder: (context) {
                    if (notification!.type == StringConstants.like) {
                      return Icon(
                        Icons.thumb_up_sharp,
                        color: ColorConstants.secondaryColor,
                        size: 12,
                      );
                    }
                    if (notification?.type == StringConstants.comment) {
                      return Icon(
                        HugeIcons.strokeRoundedMessage02,
                        color: ColorConstants.secondaryColor,
                        size: 12,
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ))
        ],
      ),
    );
  }
}

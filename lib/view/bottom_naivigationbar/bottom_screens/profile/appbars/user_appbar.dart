import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/current_user_profile_screen.dart';
import 'package:stuedic_app/view/screens/edit_profile_screen.dart';
import 'package:stuedic_app/view/screens/notification_screen.dart';
import 'package:stuedic_app/view/screens/pdf_viewer_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/profile_action_button.dart';
import 'package:stuedic_app/model/user_current_detail_model.dart';

class UserProfileAppbar extends StatelessWidget {
  const UserProfileAppbar({
    super.key,
    required this.user,
    required this.isCurrentUser,
  });

  final Response? user;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // floating: true,
      // pinned: true,
      expandedHeight: context.screenHeight * 0.39,
      actions: [
        IconButton(
          onPressed: () {
            AppRoutes.push(context, NotificationScreen());
          },
          icon: Icon(HugeIcons.strokeRoundedNotification01),
        ),
        IconButton(
          onPressed: () {
            AppRoutes.push(context, SettingScreen());
          },
          icon: Icon(Icons.more_horiz),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 178,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(ImageConstants.userProfileBg),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 9, right: 9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 110),
                              CircleAvatar(
                                radius: 62,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: AppUtils.getProfile(
                                    url: user?.profilePicUrl,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 20,
                            children: [
                              ProfileActionButton(
                                iconData: CupertinoIcons.doc_text,
                                onTap: () {
                                  AppRoutes.push(
                                      context, PdfViewerScreen(url: pdfUrl));
                                },
                              ),
                              isCurrentUser
                                  ? GradientButton(
                                      outline: user?.isFollowed ?? false,
                                      onTap: () {
                                        AppRoutes.push(
                                          context,
                                          EditProfileScreen(
                                            username: user?.userName ?? '',
                                            bio: 'bio',
                                            number: user?.phone ?? 'No Number',
                                            url: user?.profilePicUrl ?? '',
                                          ),
                                        );
                                      },
                                      height: 48,
                                      width: 120,
                                      isColored: !(user?.isFollowed ?? false),
                                      label: 'Edit Profile',
                                    )
                                  : GradientButton(
                                      outline: user?.isFollowed ?? false
                                          ? true
                                          : false,
                                      onTap: () {
                                        context
                                            .read<ProfileController>()
                                            .toggleUser(
                                                followBool:
                                                    user?.isFollowed ?? false,
                                                userId: user?.userId ?? '',
                                                context: context);
                                      },
                                      height: 48,
                                      width: 100,
                                      isColored: user?.isFollowed ?? false
                                          ? false
                                          : true,
                                      label: user?.isFollowed ?? false
                                          ? 'Following'
                                          : 'Follow',
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.userName ?? '',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('@${user?.userId ?? ''}',
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text(user?.collageName ?? '',
                      style: StringStyle.normalText()),
                  Text('Trivandrum, Kerala', style: StringStyle.normalText()),
                  SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      counts(
                          count: AppUtils.formatCounts(user?.postCount ?? 0),
                          label: "Posts"),
                      counts(
                          count:
                              AppUtils.formatCounts(user?.followingCount ?? 0),
                          label: "Following"),
                      counts(
                          count:
                              AppUtils.formatCounts(user?.followersCount ?? 0),
                          label: "Followers"),
                      counts(count: AppUtils.formatCounts(0), label: "Likes"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

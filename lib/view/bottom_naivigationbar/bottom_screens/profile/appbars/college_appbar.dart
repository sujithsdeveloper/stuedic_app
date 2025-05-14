import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/elements/details_item.dart';
import 'package:stuedic_app/elements/profileCounts.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/shareBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/data/dummyDB.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/profile/current_user_profile_screen.dart';
import 'package:stuedic_app/view/screens/club_screen.dart';
import 'package:stuedic_app/view/screens/college/college_departments.dart';
import 'package:stuedic_app/view/screens/edit_profile_screen.dart';
import 'package:stuedic_app/view/screens/notification_screen.dart';
import 'package:stuedic_app/view/screens/pdf_viewer_screen.dart';
import 'package:stuedic_app/view/screens/settings/setting_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/profile_action_button.dart';
import 'package:stuedic_app/model/user_current_detail_model.dart';

class CollegeProfileAppbar extends StatelessWidget {
  const CollegeProfileAppbar({
    super.key,
    required this.user,
    required this.isCurrentUser,
  });

  final Response? user;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: context.screenHeight,
      actions: [
        GestureDetector(
            onTap: () {
              AppRoutes.push(context, NotificationScreen());
            },
            child: Icon(HugeIcons.strokeRoundedNotification01)),
        SizedBox(width: 10),
        GestureDetector(
            onTap: () {
              shareBottomSheet(context);
            },
            child: Icon(Icons.share_outlined)),
        SizedBox(width: 10),
        GestureDetector(
            onTap: () {
              AppRoutes.push(context, SettingScreen());
            },
            child: Icon(Icons.more_horiz))
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 178,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(ImageConstants.collegeProfileBg))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 110,
                        ),
                        CircleAvatar(
                          radius: 62,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: AppUtils.getProfile(
                                url: user?.profilePicUrl ?? null),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user?.userName ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${user?.userId ?? ''}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                // ProfileActionButton(
                //   iconData: CupertinoIcons.doc_text,
                //   onTap: () {},
                // ),
                isCurrentUser
                    ? GradientButton(
                        outline: user?.isFollowed ?? false ? true : false,
                        onTap: () {
                          AppRoutes.push(
                              context,
                              EditProfileScreen(
                                isCollege: user?.isCollege ?? false,
                                bio: user?.bio ?? "",
                                number: user?.phone ?? '',
                                url: user?.profilePicUrl ?? '',
                                username: user?.userName ?? '',
                              ));
                        },
                        height: 48,
                        width: 100,
                        isColored: user?.isFollowed ?? false ? false : true,
                        label: 'Edit Profile')
                    : GradientButton(
                        outline: user?.isFollowed ?? false ? true : false,
                        onTap: () {
                          context.read<ProfileController>().toggleUser(
                              followBool: user?.isFollowed ?? false,
                              userId: user?.userId ?? '',
                              context: context);
                        },
                        height: 48,
                        width: 100,
                        isColored: user?.isFollowed ?? false ? false : true,
                        label:
                            user?.isFollowed ?? false ? 'Following' : 'Follow',
                      ),
              ],
            ),
            SizedBox(
              height: 9,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          counts(
                              count: AppUtils.formatCounts(
                                  user?.collageStrength ?? 0),
                              label: "Students"),
                          counts(
                              count: AppUtils.formatCounts(0), label: "Staffs"),
                          counts(
                              onTap: () {
                                AppRoutes.push(context, CollegeDepartments());
                              },
                              count: AppUtils.formatCounts(
                                  user?.allDepartments?.length ?? 0),
                              label: "Departments"),
                          counts(
                              onTap: () {
                                AppRoutes.push(context, ClubScreen());
                              },
                              count: AppUtils.formatCounts(0),
                              label: "Clubs"),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Details',
                          style: StringStyle.normalTextBold(size: 16),
                        ),
                      ),
                      DetailsItem(
                          title: 'Address',
                          subtitle: lorum,
                          iconData: CupertinoIcons.location),
                      DetailsItem(
                          onIconTap: () {
                            if (user?.email != null) {
                              EasyLauncher.email(email: user?.email ?? '');
                            } else {
                              AppUtils.showToast(
                                toastMessage: 'Email not provided',
                              );
                            }
                          },
                          title: 'Email',
                          subtitle: user?.email ?? 'Not Provided',
                          iconData: CupertinoIcons.envelope),
                      DetailsItem(
                          onIconTap: () {
                            if (user?.email != null) {
                              EasyLauncher.call(number: user?.phone ?? '');
                            } else {
                              AppUtils.showToast(
                                toastMessage: 'Phone number not provided',
                              );
                            }
                          },
                          title: 'Phone Number',
                          subtitle: user?.phone ?? 'Not Provided',
                          iconData: HugeIcons.strokeRoundedCall),
                      DetailsItem(
                          title: 'Affiliation',
                          subtitle: "Dummy University",
                          iconData: Icons.school_outlined),
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

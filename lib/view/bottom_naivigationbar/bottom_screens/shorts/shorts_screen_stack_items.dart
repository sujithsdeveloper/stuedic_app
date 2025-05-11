import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/shorts_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';
import 'package:stuedic_app/model/get_shorts_model.dart';

class BottomCaption extends StatelessWidget {
  const BottomCaption({super.key, required this.reel});
  final Response? reel;
  @override
  Widget build(BuildContext context) {
    return Text(reel?.postDescription ?? '',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: StringStyle.normalText(size: 12).copyWith(color: Colors.white));
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.reel});

  final Response? reel;

  @override
  Widget build(BuildContext context) {
    final userDataProviderWatch = context.watch<ProfileController>();

    return ListTile(
      leading: GestureDetector(
          onTap: () {
            AppRoutes.push(context, UserProfile(userId: reel?.userId ?? ''));
          },
          child: CircleAvatar(
            backgroundImage: AppUtils.getProfile(url: reel?.profilePicUrl),
          )),
      title: Text(
        reel?.username ?? 'unknown user',
        style: StringStyle.normalTextBold(
          color: Colors.white,
          size: 17,
        ),
      ),
      subtitle: Text(
        reel?.userId ?? '',
        style: StringStyle.normalText(
          size: 10,
        ).copyWith(
          color: Colors.white,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              context.read<ProfileController>().toggleUser(
                  followBool: reel?.isFollowed ?? false,
                  userId: reel?.userId ?? '',
                  context: context);
            },
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                    userDataProviderWatch.isFollowed ?? false
                        ? 'unfollow'
                        : 'Follow',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              bool isRightUser = await AppUtils.checkUserIdForCurrentUser(
                  IDtoCheck: reel?.userId ?? '');
              // postBottomSheet(
              //   isSaved: reel?.is ?? false,
              //     context: context,
              //     imageUrl: '',
              //     postId: reel?.postId ?? ' ',
              //     isRightUser: isRightUser,
              //     username: reel?.username ?? '');
            },
            icon: const Icon(Icons.more_horiz, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

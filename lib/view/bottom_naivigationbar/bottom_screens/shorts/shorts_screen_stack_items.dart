import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/follow_btn_bloc/follow_btn_bloc.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/postBottomSheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/view/screens/user_profile/user_profile.dart';
import 'package:stuedic_app/model/get_shorts_model.dart';
import 'package:stuedic_app/widgets/caption_widget.dart';

class BottomCaption extends StatelessWidget {
  const BottomCaption({super.key, required this.reel});
  final Response? reel;
  @override
  Widget build(BuildContext context) {
    return CaptionWidget(
      caption: reel?.postDescription ?? '',
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.reel});

  final Response? reel;

  @override
  Widget build(BuildContext context) {
    final userDataProviderWatch = context.watch<ProfileController>();
    log(reel!.isFollowed.toString(), name: '\x1B[32m reel follow bool ');

    return ListTile(
      leading: GestureDetector(
          onTap: () {
            AppRoutes.push(context, UserProfile(userId: reel?.userId ?? ''));
          },
          child: CircleAvatar(
            backgroundImage: AppUtils.getProfile(url: reel?.profilePicUrl),
          )),
      title: Text(
        AppUtils.getUserNameById(reel?.username),
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
          BlocBuilder<FollowBtnBloc, FollowBtnState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<FollowBtnBloc>(context).add(FollowBtnEvent(
                      followersCount: 0,
                      userId: reel!.userId.toString(),
                      context: context));
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
                        state.reelboolChange ?? false ? 'following' : 'Follow',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () async {
              bool isRightUser = await AppUtils.checkUserIdForCurrentUser(
                  IDtoCheck: reel?.userId ?? '');
              // postBottomSheet(
              //   isSaved: reel?. ?? false,
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

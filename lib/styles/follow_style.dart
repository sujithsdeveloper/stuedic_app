import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/follow_btn_bloc/follow_btn_bloc.dart';
import 'package:stuedic_app/widgets/custom_buttons.dart';

class FollowButton extends StatelessWidget {
  const FollowButton(
      {super.key,
      required this.userId,
      required this.followState,
      this.outLinedButton = false,
      required this.isFollowed});
  final String userId;
  final FollowBtnState followState;
  final bool outLinedButton;
  final bool isFollowed;
  @override
  Widget build(BuildContext context) {
    return outLinedButton
        ? CustomOutLinedButton(
            label: followState.isFollow ? 'Following' : 'Follow',
            onTap: () {
              BlocProvider.of<FollowBtnBloc>(context)
                  .add(FollowBtnEvent(userId: userId, context: context));
            },
          )
        : GradientButton(
            onTap: () {
              BlocProvider.of<FollowBtnBloc>(context)
                  .add(FollowBtnEvent(userId: userId, context: context));
            },
            height: 48,
            width: 100,
            isColored: !followState.isFollow,
            label: followState.isFollow ? 'Following' : 'Follow',
          );
  }
}

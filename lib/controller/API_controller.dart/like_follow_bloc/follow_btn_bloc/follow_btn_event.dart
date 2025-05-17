// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'follow_btn_bloc.dart';

class FollowBtnEvent {
  String userId;
  BuildContext context;
  int followersCount;
  FollowBtnEvent({
    required this.userId,
    required this.context,
    required this.followersCount,
  });
}

class UpdateFollowStatusEvent extends FollowBtnEvent {
  final bool isFollowed;

  UpdateFollowStatusEvent(
      {required this.isFollowed,
      required super.userId,
      required super.context,
      required super.followersCount});
}

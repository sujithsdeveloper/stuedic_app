import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';

part 'follow_btn_event.dart';
part 'follow_btn_state.dart';

class FollowBtnBloc extends Bloc<FollowBtnEvent, FollowBtnState> {
  FollowBtnBloc({required bool initialFollowStatus})
      : super(FollowBtnState(
            isFollow: initialFollowStatus,
            reelboolChange: initialFollowStatus)) {
    on<FollowBtnEvent>(_onfollowBTNClick);
    on<UpdateFollowStatusEvent>(_onUpdateFollowStatus);
  }

  Future<void> _onfollowBTNClick(
      FollowBtnEvent event, Emitter<FollowBtnState> emit) async {
    final followApiCall = event.context.read<ProfileController>();
    bool followfrominitial = state.isFollow;
    int newFollowersCount = event.followersCount;
    log(followfrominitial.toString(),
        name: "\x1B[37m initial follow status from bloc");
    if (followfrominitial) {
      // Unfollow
      newFollowersCount = (newFollowersCount > 0) ? newFollowersCount - 1 : 0;
      emit(FollowBtnState(
          isFollow: false,
          reelboolChange: false,
          followersCount: newFollowersCount));
      await followApiCall.unfollowUser(
          userId: event.userId, context: event.context);
    } else {
      // Follow
      newFollowersCount = newFollowersCount + 1;
      emit(FollowBtnState(
          isFollow: true,
          reelboolChange: true,
          followersCount: newFollowersCount));
      await followApiCall.followUser(
          userId: event.userId, context: event.context);
      log(newFollowersCount.toString(),
          name:
              "\x1B[37m initial follow status from bloc after increasing count");
    }
  }

  Future<void> _onUpdateFollowStatus(
      UpdateFollowStatusEvent event, Emitter<FollowBtnState> emit) async {
    emit(FollowBtnState(
        followersCount: event.followersCount,
        isFollow: event.isFollowed,
        reelboolChange: event.isFollowed));
  }
}

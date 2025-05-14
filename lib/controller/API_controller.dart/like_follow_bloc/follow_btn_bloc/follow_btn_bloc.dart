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
      : super(FollowBtnState(isFollow: initialFollowStatus)) {
    on<FollowBtnEvent>(_onfollowBTNClick);
  }

  Future<void> _onfollowBTNClick(
      FollowBtnEvent event, Emitter<FollowBtnState> emit) async {
    final followApiCall = event.context.read<ProfileController>();
    bool followfrominitial = state.isFollow;
    log(followfrominitial.toString(),
        name: "\x1B[37m initial follow status from bloc");
    if (followfrominitial) {
      emit(FollowBtnState(isFollow: !followfrominitial));
      await followApiCall.unfollowUser(
          userId: event.userId, context: event.context);
    } else {
      emit(FollowBtnState(isFollow: !followfrominitial));
      await followApiCall.followUser(
          userId: event.userId, context: event.context);
    }
  }
}

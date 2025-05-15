import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/like_bloc/post_like_event.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/like_bloc/post_likr_state.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';

class PostLikeBloc extends Bloc<PostLikeEvent, PostLikrState> {
  PostLikeBloc({required int initialCount, required bool initialbool})
      : super(PostLikrState(count: initialCount, likebool: initialbool)) {
    on<PostLikeEvent>((event, emit) async {
      log('like bloc call --', name: '\x1B[32m like bloc call');
      final interaction = event.context.read<PostInteractionController>();

      final currentLiked = state.likebool;
      final currentCount = state.count;

      if (currentLiked) {
        emit(PostLikrState(count: currentCount - 1, likebool: false));
        await interaction.unLikePost(
            postId: event.postId, context: event.context);
      } else {
        emit(PostLikrState(count: currentCount + 1, likebool: true));
        await interaction.likePost(
            postId: event.postId, context: event.context);
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/like_bloc/post_like_bloc.dart';
import 'package:stuedic_app/controller/API_controller.dart/like_follow_bloc/like_bloc/post_likr_state.dart';
import 'package:stuedic_app/controller/API_controller.dart/post_interaction_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class PostLikeStyles extends StatefulWidget {
  const PostLikeStyles(
      {super.key,
      required this.postId,
      required this.likeCount,
      required this.isLiked,
      required this.callBackFunction,
      this.showCount = true,
      this.horizontalDirection = true,
      this.spaceing,
      this.iconColor = ColorConstants.secondaryColor,
      this.textColor});
  final String postId;
  final Color iconColor;
  final String likeCount;
  final Color? textColor;
  final bool isLiked;
  final Function() callBackFunction;
  final bool showCount;
  final bool horizontalDirection;
  final double? spaceing;
  @override
  State<PostLikeStyles> createState() => _PostLikeStylesState();
}

class _PostLikeStylesState extends State<PostLikeStyles>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    final interaction = context.read<PostInteractionController>();
    interaction.isLiked = widget.isLiked;
    interaction.countLike = int.parse(widget.likeCount);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostLikeBloc, PostLikrState>(
      builder: (context, state) {
        return widget.horizontalDirection
            ? Row(
                spacing: widget.spaceing ?? 0,
                children: [
                  likeIcon(context, blocLikeBool: state.likebool),
                  Visibility(
                    visible: widget.showCount,
                    child: Text(
                      state.count.toString(),
                      // postInteraction.countLike.toString(),
                      style: StringStyle.smallText(isBold: true),
                    ),
                  ),
                ],
              )
            : Column(
                spacing: widget.spaceing ?? 0,
                children: [
                  likeIcon(context, blocLikeBool: state.likebool),
                  Visibility(
                    visible: widget.showCount,
                    child: Text(
                      AppUtils.formatCounts(state.count),
                      style: StringStyle.smallText(
                          isBold: true, color: Colors.white),
                    ),
                  ),
                ],
              );
      },
    );
  }

  GestureDetector likeIcon(BuildContext context, {required bool blocLikeBool}) {
    return GestureDetector(
      onTap: () async {
        await animationController.forward().then(
          (value) async {
            await animationController.reverse();
          },
        );

        widget.callBackFunction();
      },
      child: AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: Icon(
              blocLikeBool == true
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: blocLikeBool == true ? Colors.red : widget.iconColor,
              size: 28,
            ),
          );
        },
      ),
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';

class UnlikeIcon extends StatelessWidget {
  const UnlikeIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(CupertinoIcons.heart);
  }
}

class LikeAnimation extends StatelessWidget {
  const LikeAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Lottie.asset(
          repeat: false, LottieAnimations.like),
    );
  }
}

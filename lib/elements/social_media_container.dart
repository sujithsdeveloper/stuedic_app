
import 'package:flutter/cupertino.dart';

class SocialMediaContainer extends StatelessWidget {
  const SocialMediaContainer({
    super.key,
    required this.child,
    this.onTap,
  });
  final Widget child;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 103.67,
        height: 56,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Color(0xffE7ECF0))),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

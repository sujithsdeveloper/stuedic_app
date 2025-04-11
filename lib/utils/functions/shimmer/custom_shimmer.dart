import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({super.key, required this.child});
final Widget child;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(child: child,   baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,);
  }
}


class TextShimmer extends StatelessWidget {
  const TextShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(child: 
      Container(
        height: 20,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class IconShimmer extends StatelessWidget {
  const IconShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(child: 
      Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}


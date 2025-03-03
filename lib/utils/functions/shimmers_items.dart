import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmersItems {
 static Widget imagePickerShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

}
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

  static Widget imageShimmer(){
    return Shimmer.fromColors(child: Container(
      height: double.infinity,
      width: double.infinity,
    ),    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,);
  }


}
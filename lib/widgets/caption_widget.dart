import 'package:flutter/material.dart';

class CaptionWidget extends StatelessWidget {
  const CaptionWidget({super.key, required this.caption});
final String caption;
  @override
  Widget build(BuildContext context) {
    return Text(caption);
  }
}
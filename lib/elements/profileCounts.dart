
import 'package:flutter/material.dart';

class counts extends StatelessWidget {
  counts({super.key, required this.count, required this.label});

  final String count; // Change from int to String
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'latoRegular')),
        Text(label, style: TextStyle(fontFamily: 'latoRegular'))
      ],
    );
  }
}

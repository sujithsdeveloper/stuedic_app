import 'package:flutter/material.dart';

class CustomPopupMenu extends StatelessWidget {
  const CustomPopupMenu({super.key, required this.items});
  final List<PopupMenuEntry<String>> items;
  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return PopupMenuButton<String>(
      color: isDark ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      borderRadius: BorderRadius.circular(10),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => items,
    );
  }
}

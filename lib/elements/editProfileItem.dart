
import 'package:flutter/material.dart';

class EditItem extends StatelessWidget {
  const EditItem({
    super.key,
    required this.label,
    required this.data,
    this.onTap,
  });

  final String label;
  final String data;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(data, style: const TextStyle(color: Colors.grey)),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

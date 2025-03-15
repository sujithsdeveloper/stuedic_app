import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';

class EditItem extends StatelessWidget {
  const EditItem({
    super.key,
    required this.label,
    required this.controller,
    required this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final String suffix;
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 9),
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: StringStyle.normalTextBold(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

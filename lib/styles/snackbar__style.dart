import 'package:flutter/material.dart';

errorSnackbar(
    {required String label,
    Color bgColor = Colors.red,
    required BuildContext context}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    showCloseIcon: true,
    behavior: SnackBarBehavior.floating,
    content: Text(label),
    backgroundColor: bgColor,
  ));
}

customSnackbar({required String label, Color, required BuildContext context}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(label),
  ));
}

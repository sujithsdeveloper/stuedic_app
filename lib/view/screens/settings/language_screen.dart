import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Language",
          style: StringStyle.appBarText(),
        ),
      ),
      body: ListTile(
        leading: Text(
          "English",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        trailing: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';

class CollegeDetailTile extends StatelessWidget {
  const CollegeDetailTile({super.key, required this.iconData, required this.label, required this.subLabel});
final IconData iconData;
final String label;
final String subLabel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label,style: StringStyle.normalTextBold(),),
      subtitle: Text(subLabel,style: StringStyle.normalTextBold(),),
      trailing: Icon(iconData),
    );
  }
}
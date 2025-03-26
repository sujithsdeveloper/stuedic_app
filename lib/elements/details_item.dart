import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/widgets/custom_list_tile.dart';

class DetailsItem extends StatelessWidget {
  const DetailsItem(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.iconData});
  final String title;
  final String subtitle;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: StringStyle.normalTextBold(),
      ),
      subtitle: SizedBox(
        child: Text(
          subtitle,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Icon(iconData),
    );
  }
}

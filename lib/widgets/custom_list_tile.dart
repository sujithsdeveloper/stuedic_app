import 'package:flutter/cupertino.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
       this.leading,
      this.trailing,
      this.title,
      this.subtitle,
      this.onTap,
      this.onLongTap});
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? subtitle;
  final Function()? onTap;
  final Function()? onLongTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongTap,
        child: Row(
          children: [
            SizedBox(width: 50, height: 50, child: Center(child: leading)),
            SizedBox(
              width: 9,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(child: title), SizedBox(child: subtitle,)],
            ),
            Spacer(),
            SizedBox(child: trailing)
          ],
        ),
      ),
    );
  }
}

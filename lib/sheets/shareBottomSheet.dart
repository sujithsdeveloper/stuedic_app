import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/widgets/gradient_circle_avathar.dart';

Future<dynamic> shareBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7, // Start with 60% of screen height
      minChildSize: 0.4, // Min height when dragged down
      builder: (context, scrollController) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedShare05,
                      size: 20,
                    ),
                    Text(
                      'Share',
                      style: StringStyle.normalTextBold(),
                    )
                  ],
                ),
              ),
              SizedBox(height: 32),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 14,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        spacing: 4,
                        children: [
                          GradientCircleAvathar(
                            radius: 52,
                            child: Icon(Icons.add),
                          ),
                          Text(
                            'Add to Story',
                            style: StringStyle.normalText(size: 12),
                          ),
                        ],
                      ),
                    ),
                    ShareItems(
                        icon: Icon(
                          CupertinoIcons.link,
                        ),
                        text: 'Copy Link'),
                    ShareItems(
                        icon: Brand(
                          Brands.instagram,
                        ),
                        text: 'Instagram'),
                    ShareItems(
                        icon: Brand(
                          Brands.whatsapp,
                        ),
                        text: 'Whatsapp'),
                    ShareItems(
                        icon: Brand(
                          Brands.facebook,
                        ),
                        text: 'Facebook'),
                    ShareItems(
                        icon: Icon(CupertinoIcons.chat_bubble), text: 'SMS'),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(CupertinoIcons.search),
                    hintText: 'Search',
                    filled: true,
                    fillColor: Color(0xffF6F8F9),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 5,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(''),
                    ),
                    title: Text(
                      // items[index]['username'],
                      '',
                      style: StringStyle.normalTextBold(),
                    ),
                    trailing: Container(
                      height: 28,
                      width: 62,
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorConstants.greyColor),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          "Send",
                          style: StringStyle.normalText(),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

class ShareItems extends StatelessWidget {
  const ShareItems({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });
  final String text;
  final Widget icon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: ColorConstants.greyColor,
            radius: 26,
            child: icon,
          ),
        ),
        Text(
          text,
          style: StringStyle.normalText(size: 12),
        ),
      ],
    );
  }
}

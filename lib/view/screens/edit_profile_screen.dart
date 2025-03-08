import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/elements/editProfileItem.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({
    super.key,
    required this.name,
    required this.Username,
    required this.bio,
  });

  final String name;
  final String Username;
  final String bio;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    usernameController.text = widget.Username;
    bioController.text = widget.bio;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> profileData = [
      {
        'label': 'Name',
        'data': widget.name,
        'onTap': () {
          print("Edit Name");
        }
      },
      {
        'label': 'Username',
        'data': widget.Username,
        'onTap': () {
          print("Edit Username");
        }
      },
      {
        'label': 'Bio',
        'data': widget.bio,
        'onTap': () {
          print("Edit Bio");
        }
      },
    ];

    final List<Map<String, dynamic>> socialLinks = [
      {
        'label': 'Instagram',
        'data': 'Add Instagram',
        'onTap': () => print("Add Instagram")
      },
      {
        'label': 'YouTube',
        'data': 'Add YouTube',
        'onTap': () => print("Add YouTube")
      },
      {
        'label': 'Twitter',
        'data': 'Add Twitter',
        'onTap': () => print("Add Twitter")
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundColor: ColorConstants.primaryColor2,
                    child: const CircleAvatar(
                      radius: 62,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        mediaBottomSheet(
                          context: context,
                          onCameraTap: (pickedImage) {},
                          onGalleryTap: (pickedImage) {},
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: ColorConstants.secondaryColor,
                        child: Icon(
                          CupertinoIcons.add,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "About you",
              style: TextStyle(fontSize: 16, fontFamily: 'latoRegular'),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => EditItem(
                label: profileData[index]['label'],
                data: profileData[index]['data'],
                onTap: profileData[index]['onTap'],
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: profileData.length,
            ),
            const SizedBox(height: 20),
            const Text(
              "Social",
              style: TextStyle(fontSize: 16, fontFamily: 'latoRegular'),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => EditItem(
                label: socialLinks[index]['label'],
                data: socialLinks[index]['data'],
                onTap: socialLinks[index]['onTap'],
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: socialLinks.length,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/API_controller.dart/editprofile_controller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/elements/editProfileItem.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({
    super.key,
    required this.username,
    required this.bio,
    required this.number,
    required this.url,
  });

  final String username;
  final String bio;
  final String number;

  final String url;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final numberController = TextEditingController();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    numberController.text = widget.number;
    usernameController.text = widget.username;
    bioController.text = widget.bio;
  }

  @override
  Widget build(BuildContext context) {
    final url = context.watch<MutlipartController>().imageUrl;
    final path = context.watch<AssetPickerController>().pickedImage;
    final isLoading = context.watch<AssetPickerController>().isLoading;
    final List<Map<String, dynamic>> profileData = [
      {
        'label': 'Username',
        'data': widget.username,
        'controller': usernameController,
      },
      {
        'label': 'Bio',
        'data': widget.bio,
        'controller': bioController,
      },
      {
        'label': 'Phone number',
        'data': widget.number,
        'controller': numberController,
      },
    ];

    return WillPopScope(
      onWillPop: () async {
        if (widget.number == numberController.text &&
            widget.username == usernameController.text &&
            widget.bio == bioController.text &&
            path == null) {
          return true;
        } else {
          bool? shouldPop = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CupertinoAlertDialog(
                    title: const Text('Unsaved Changes'),
                    content: const Text(
                        'Do you want to save changes before leaving?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          context.watch<AssetPickerController>().pickedImage =
                              null;
                        },
                        child: const Text('Discard'),
                      ),
                    ],
                  ));
          return shouldPop ?? false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  context
                      .read<EditprofileController>()
                      .editProfile(
                          name: usernameController.text,
                          bio: bioController.text,
                          number: numberController.text,
                          url: url!,
                          context: context)
                      .then(
                    (value) {
                      context.watch<AssetPickerController>().pickedImage = null;
                    },
                  );
                },
                child: Text('Save'))
          ],
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
                      child: CircleAvatar(
                          radius: 62,
                          backgroundImage: path == null
                              ? AppUtils.getProfile(url: url)
                              : AppUtils.getProfileLocal(image: path)),
                    ),
                    Visibility(
                        visible: isLoading,
                        child: Positioned.fill(
                            child: CircularProgressIndicator())),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          mediaBottomSheet(
                            context: context,
                            onCameraTap: (pickedImage) {
                              context.read<MutlipartController>().uploadMedia(
                                  context: context,
                                  filePath: pickedImage!.path,
                                  API: APIs.uploadPicForPost);
                            },
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
              Text(
                "About you",
                style: StringStyle.normalText(size: 16),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final items = profileData[index];
                  return EditItem(
                    controller: items['controller'] as TextEditingController,
                    label: items['label'],
                    suffix: items['data'],
                  );
                },
                itemCount: profileData.length,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/controller/API_controller.dart/editprofile_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/profile_controller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/elements/editProfileItem.dart';
import 'package:stuedic_app/extensions/shortcuts.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({
    super.key,
    required this.username,
    required this.bio,
    required this.number,
    required this.url,
    required this.isCollege,
  });

  final String username;
  final String bio;
  final String number;
  final bool isCollege;
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
          title: Text(
            'Edit Profile',
            style: StringStyle.appBarText(context: context),
          ),
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
                          url: url ?? '',
                          context: context)
                      .then(
                    (value) {
                      context.watch<AssetPickerController>().pickedImage = null;
                      context
                          .read<HomefeedController>()
                          .getAllPost(context: context);
                      context
                          .read<ProfileController>()
                          .getCurrentUserData(context: context);
                    },
                  );
                },
                child:
                    Text('Save', style: StringStyle.normalTextBold(size: 16))),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 7,
                            child: SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: Image.asset(
                                ImageConstants.userProfileBg,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              right: 9,
                              top: 9,
                              child: GestureDetector(
                                onTap: () {
                                  mediaBottomSheet(
                                    context: context,
                                    onCameraTap: () {
                                      context
                                          .read<AssetPickerController>()
                                          .pickImage(
                                            aspectRatio: CropAspectRatio(
                                                ratioX: 16, ratioY: 7),
                                            context: context,
                                            source: ImageSource.camera,
                                          );
                                    },
                                    onGalleryTap: () {
                                      context
                                          .read<AssetPickerController>()
                                          .pickImage(
                                            aspectRatio: CropAspectRatio(
                                                ratioX: 16, ratioY: 7),
                                            context: context,
                                            source: ImageSource.gallery,
                                          );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      ColorConstants.darkSecondaryColor,
                                  radius: 20,
                                  child: Icon(Icons.edit,
                                      color: ColorConstants.primaryColor2),
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                  Positioned(
                    top: 100,
                    right: context.screenWidth * 0.5 - 64,
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
                                onCameraTap: () {
                                  context
                                      .read<AssetPickerController>()
                                      .pickImage(
                                        aspectRatio: CropAspectRatio(
                                            ratioX: 1, ratioY: 1),
                                        context: context,
                                        source: ImageSource.camera,
                                      );
                                },
                                onGalleryTap: () {
                                  context
                                      .read<AssetPickerController>()
                                      .pickImage(
                                        aspectRatio: CropAspectRatio(
                                            ratioX: 1, ratioY: 1),
                                        context: context,
                                        source: ImageSource.gallery,
                                      );
                                },
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
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "About you",
                style: StringStyle.normalText(size: 16),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
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
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

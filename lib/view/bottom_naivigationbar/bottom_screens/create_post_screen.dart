import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_controller.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/controller/mutlipart_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/view/screens/chat_list_screen.dart';
import 'package:stuedic_app/view/screens/notification_default_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final proRead = context.read<CrudOperationController>();
    final proReadAsset = context.read<AssetPickerController>();
    final proWatchAsset = context.watch<AssetPickerController>();
    final proWatchApp = context.watch<AppContoller>();

    return Scaffold(
      backgroundColor: ColorConstants.greyColor,
      appBar: AppBar(
        title: Text(
          "Stuedic",
          style: StringStyle.normalTextBold(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedNotification01,
              color: Colors.black,
            ),
            onPressed: () {
              AppRoutes.push(context, NotificationDefaultScreen());
            },
          ),
          IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedMessage01,
              color: Colors.black,
            ),
            onPressed: () {
              AppRoutes.push(context, ChatListScreen());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Text(
              'Create',
              style: StringStyle.normalTextBold(size: 18),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TabBar(
                      splashFactory: NoSplash.splashFactory,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        color: ColorConstants.primaryColor2,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      controller: tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      dividerHeight: 0,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Post'),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Reel'),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Story'),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            PostSection(),
                            Center(child: Text("Create a Reel")),
                            Center(child: Text("Create a Story")),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostSection extends StatelessWidget {
  const PostSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final proRead = context.read<CrudOperationController>();
    final proReadAsset = context.read<AssetPickerController>();
    final proWatchAsset = context.watch<AssetPickerController>();
    final multipartObj = context.watch<MutlipartController>();
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 293,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffF5FFE1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: proWatchAsset.pickedAsset == null
                    ? GradientButton(
                        label: 'Upload image',
                        onTap: () {
                          mediaBottomSheet(
                              context: context,
                              onCameraTap: () async {
                                await proReadAsset.pickImage(
                                    context: context,
                                    source: ImageSource.camera);
                              },
                              onGalleryTap: () async {
                                await proReadAsset.pickImage(
                                    context: context,
                                    source: ImageSource.gallery);
                              });
                        },
                      )
                    : Stack(
                        children: [
                          Image.file(proWatchAsset.pickedAsset!),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                proReadAsset.pickedAsset = null;
                                proReadAsset.notifyListeners();
                              },
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ),
          Text(
            'Caption',
            style: StringStyle.normalTextBold(size: 18),
          ),
          TextfieldWidget(
            hint: 'Write a caption',
            controller: controller,
            maxLength: 250,
          ),
          Spacer(),
          GradientButton(
            label: 'Post',
            isColored: true,
            onTap: () {
              if (proWatchAsset.pickedAsset == null) {
                return;
              }

              proRead.uploadPost(
                  imagePath: multipartObj.imageUrl ?? '',
                  caption: controller.text.isEmpty ? '' : controller.text,
                  context: context);
              controller.clear();
              proReadAsset.pickedAsset = null;
              proReadAsset.notifyListeners();
              context.read<HomefeedController>().getAllPost(context: context);
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}

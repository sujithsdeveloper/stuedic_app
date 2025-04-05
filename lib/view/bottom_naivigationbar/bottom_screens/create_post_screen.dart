import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/crud_operation_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/controller/asset_picker_controller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/tabbar_screens/create_story_section.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/tabbar_screens/post_section.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_screens/tabbar_screens/reel_section.dart';
import 'package:stuedic_app/view/screens/notification_screen.dart';
import 'package:stuedic_app/widgets/gradient_container.dart';

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

    return WillPopScope(
      onWillPop: () async {
        if (proWatchAsset.pickedImage != null) {
          proReadAsset.clearAsset();
          return true;
        }

        return true;
      },
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await proReadAsset.pickImage(
        //         source: ImageSource.gallery, context: context);
        //   },
        // ),
        appBar: AppBar(
          title: Row(
            spacing: 9,
            children: [
              GradientContainer(
                height: 23,
                width: 9,
                verticalGradient: true,
              ),
              Text(StringConstants.appName,
                  style: StringStyle.appBarText(context: context)),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                HugeIcons.strokeRoundedNotification01,
                color: Colors.black,
              ),
              onPressed: () {
                AppRoutes.push(context, NotificationScreen());
              },
            ),
            IconButton(
              icon: Icon(
                HugeIcons.strokeRoundedMessage01,
                color: Colors.black,
              ),
              onPressed: () {
                // AppRoutes.push(context, ChatListScreen());
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TabBar(
                        indicatorPadding: EdgeInsets.only(bottom: 2),
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
                              child: Text(
                                'Post',
                                style: StringStyle.normalTextBold(),
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Reel',
                                style: StringStyle.normalTextBold(),
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Story',
                                style: StringStyle.normalTextBold(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              PostSection(
                                onGalleryTap: () async {
                                  await context
                                      .read<AssetPickerController>()
                                      .pickImage(
                                          source: ImageSource.gallery,
                                          context: context);
                                },
                                onCameraTap: () async {
                                  await context
                                      .read<AssetPickerController>()
                                      .pickImage(
                                          source: ImageSource.camera,
                                          context: context);
                                },
                              ),
                              ReelSection(),
                              CreateStorySection(
                                  onGalleryTap: () async {
                                       await context
                                      .read<AssetPickerController>()
                                      .pickImage(
                                        
                                          source: ImageSource.gallery,
                                          context: context);
                                  },
                                  onCameraTap: () async {
                                       await context
                                      .read<AssetPickerController>()
                                      .pickImage(
                                          source: ImageSource.camera,
                                          context: context);
                                  },)
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
      ),
    );
  }
}

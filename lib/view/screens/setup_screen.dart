import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/view/bottom_naivigationbar/bottom_nav_screen.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController controller = TextEditingController();
  final PageController pageController = PageController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int pageIndex = 0;

  @override
  void dispose() {
    controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        pageIndex = pageController.page!.round();
      });
    });
  }

  void nextPage() {
    if (pageIndex < 3) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();

    return WillPopScope(
      onWillPop: () async {
        return proRead.setupPop(
            index: pageIndex, pageController: pageController);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Setup Account',
            style: StringStyle.appBarText(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color:
                            index > pageIndex ? const Color(0xffE7ECF0) : null,
                        borderRadius: BorderRadius.circular(50),
                        gradient: index <= pageIndex
                            ? ColorConstants.primaryGradientVertical
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                itemCount: 4,
                itemBuilder: (context, index) {
                  // Update the content based on the current page index
                  switch (index) {
                    case 0:
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                Text(
                                  'Choose the one that describes you!',
                                  style: StringStyle.topHeading(size: 32),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Create your username and you can change it later.',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 24),
                                TextfieldWidget(
                                  dismissKeyboardOnTapOutside: true,
                                  helperText:
                                      "*Name should be 15 characters or less",
                                  maxLength: 15,
                                  hint: 'Username',
                                  validator: (value) =>
                                      nameValidator(value, 'Username'),
                                ),
                                const SizedBox(height: 40),
                                GradientButton(
                                  width: double.infinity,
                                  isColored: prowatch.singleFieldColored,
                                  label: 'Continue',
                                  onTap: () {
                                    if (formKey.currentState != null &&
                                        formKey.currentState!.validate()) {
                                      nextPage();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                    case 1:
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              Text(
                                'Upload Photo',
                                style: StringStyle.topHeading(size: 32),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Enhance your profile with a personal touch by adding a photo. Let your picture speak about your identity.',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor:
                                            ColorConstants.primaryColor2,
                                        radius: 64,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                              ImageConstants.avathar),
                                          radius: 62,
                                        )),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          mediaBottomSheet(context: context);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              ColorConstants.secondaryColor,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              GradientButton(
                                width: double.infinity,
                                isColored: true,
                                label: 'Continue',
                                onTap: nextPage,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GradientButton(
                                width: double.infinity,
                                label: 'MayBeLater',
                                onTap: nextPage,
                              ),
                            ],
                          ),
                        ),
                      );

                    case 2:
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Lets make a',
                                    style: StringStyle.topHeading(size: 32),
                                  ),
                                  Transform.rotate(
                                    angle: -15 * pi / 180,
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      height: 32,
                                      width: 58,
                                      decoration: BoxDecoration(
                                          gradient: ColorConstants
                                              .primaryGradientHorizontal,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Center(
                                        child: Text(
                                          'Cool',
                                          style: TextStyle(
                                              color:
                                                  ColorConstants.secondaryColor,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'lato',
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'post',
                                    style: StringStyle.topHeading(size: 32),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                textAlign: TextAlign.center,
                                'Add photos and videos from your gallery, and discover communities based on your interests.',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 40),
                              GradientButton(
                                isColored: true,
                                label: 'Create Post',
                                onTap: nextPage,
                              ),
                              const SizedBox(height: 24),
                              GradientButton(
                                isColored: false,
                                label: 'Skip',
                                onTap: nextPage,
                              ),
                            ],
                          ),
                        ),
                      );

                    case 3:
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            Text(
                              'All Done',
                              style: StringStyle.topHeading(size: 32),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Review your details before proceeding.',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 40),
                            GradientButton(
                              isColored: true,
                              label: 'Finish Setup',
                              onTap: () {
                                AppRoutes.pushAndRemoveUntil(
                                    context, BottomNavScreen());
                              },
                            ),
                          ],
                        ),
                      );

                    default:
                      return Container(); // Handle unexpected index
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

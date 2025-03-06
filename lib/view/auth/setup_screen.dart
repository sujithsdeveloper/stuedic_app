import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/routes/app_routes.dart';
import 'package:stuedic_app/sheets/media_bottom_sheet.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/asset_constants.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/view/auth/setup_screens/desigination_selection.dart';
import 'package:stuedic_app/view/auth/setup_screens/form_fill.dart';
import 'package:stuedic_app/view/auth/setup_screens/upload_profile.dart';
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
                  switch (index) {
                    case 0:
                      return DesiginationSelection(
                          prowatch: prowatch,
                          proRead: proRead,
                          nextPage: nextPage);
                    case 1:
                      return FormFill(
                          prowatch: prowatch,
                          proRead: proRead,
                          nextPage: nextPage);

                    case 2:
                      return UploadProfile(
                          prowatch: prowatch,
                          proRead: proRead,
                          nextPage: nextPage);

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

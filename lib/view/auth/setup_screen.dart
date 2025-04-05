import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/college_controller.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/view/auth/setup_screens/desigination_selection.dart';
import 'package:stuedic_app/view/auth/setup_screens/finish_setup.dart';
import 'package:stuedic_app/view/auth/setup_screens/form_fill.dart';
import 'package:stuedic_app/view/screens/initial_screen/club_selection.dart';
import 'package:stuedic_app/view/screens/initial_screen/upload_id.dart';

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


    context.read<CollegeController>().getCollege(context: context);
  }

  void nextPage() {
    if (pageIndex < 2) {
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
        if (pageIndex != 0) {
          pageController.previousPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Setup Account',
            style: StringStyle.appBarText(context: context),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(
                  3,
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
                itemCount: 3,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return DesignationSelection(
                          prowatch: prowatch,
                          proRead: proRead,
                          nextPage: nextPage);
                    case 1:
                      return FormFill(
                          prowatch: prowatch,
                          proRead: proRead,
                          nextPage: nextPage);
                    case 2:
                      return FinishSetup();

                    default:
                      return SizedBox();
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

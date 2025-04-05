import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/API_controller.dart/college_controller.dart';
import 'package:stuedic_app/controller/app/dropdown_controller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/functions/validators.dart';
import 'package:stuedic_app/widgets/dropdown_widget.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class CollegeRegistration extends StatefulWidget {
  const CollegeRegistration({
    super.key,
    required this.nextPage,
  });

  final Function() nextPage;

  @override
  State<CollegeRegistration> createState() => _CollegeRegistrationState();
}

class _CollegeRegistrationState extends State<CollegeRegistration> {
  final key = GlobalKey<FormState>();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<CollegeController>();
    final items = prowatch.getCollegeListModel?.response!;
    final dropWatch = context.watch<DropdownController>();
    final dropRead = context.read<DropdownController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              const SizedBox(height: 30),

              /// Full Name
              FormItem(
                child: TextfieldWidget(
                  borderColor: ColorConstants.greyColor,
                  hint: 'Name',
                  validator: (p0) => nameValidator(p0, 'Name'),
                  controller: nameController,
                ),
                title: 'Full Name',
              ),
              FormItem(
                title: 'Institution Name',
                child: DropdownWidget(
                  hint: 'Institution Name',
                  onChanged: (value) {
                    final selectedCollege = items!
                        .firstWhere((college) => college.collageId == value);
                    dropRead.onChanged(
                      collegeId: selectedCollege.collageId!,
                      collegeName: selectedCollege.collageName ?? '',
                      context: context,
                    );
                  },
                  items: items == null || items.isEmpty
                      ? [DropdownMenuItem(child: Text('No College found'))]
                      : List.generate(
                          items.length,
                          (index) {
                            return DropdownMenuItem(
                              child: Text(items[index].collageName ?? ''),
                              value: items[index].collageId,
                            );
                          },
                        ),
                ),
              ),

              FormItem(
                  title: 'Department Name',
                  child: DropdownWidget(
                      hint: 'Select Department',
                      onChanged: (value) {},
                      items: [
                        DropdownMenuItem(
                            child: Text(
                          'No Department found',
                          softWrap: true,
                        ))
                      ])),

              /// Continue Button
              /// Continue Button
              GradientButton(
                width: double.infinity,
                label: 'Continue',
                onTap: () async {
                  if (key.currentState!.validate()) {
                    await AppUtils.saveForm(
                      // collegeValue: dropWatch.selectedCollegeId!,
                      userName: nameController.text,
                      collegeName: dropWatch.selectedCollegeName ??
                          '', // Pass the college name
                      deptName: '',
                    );
                    widget.nextPage();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormItem extends StatelessWidget {
  const FormItem({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StringStyle.normalTextBold(size: 16),
        ),
        const SizedBox(height: 5), // Added spacing
        child,
      ],
    );
  }
}

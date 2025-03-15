import 'package:flutter/material.dart';
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
                      onChanged: (value) {},
                      items: [])),
              FormItem(
                  title: 'Department Name',
                  child: DropdownWidget(
                      hint: 'Dept Name', onChanged: (value) {}, items: [])),

              /// Continue Button
              GradientButton(
                width: double.infinity,
                label: 'Continue',
                onTap: () async {
                  if (key.currentState!.validate()) {
                         await AppUtils.saveForm(
                              userName: nameController.text,
                              collegeName: 'Providence college of engineering',
                              deptName: 'Department of computer science');
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

import 'package:flutter/material.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';
import 'package:stuedic_app/widgets/textfeild_widget.dart';

class FormFill extends StatelessWidget {
  const FormFill(
      {super.key,
      required this.prowatch,
      required this.proRead,
      required this.nextPage});
  final AppContoller prowatch;
  final AppContoller proRead;
  final Function() nextPage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
          child: Column(
        spacing: 20,
        children: [
          SizedBox(
            height: 9,
          ),
          FormItem(
            child: TextfieldWidget(hint: 'Name'),
            title: 'Full Name',
          ),
          FormItem(
            child: DropdownButtonFormField(
                hint: Text('Institution Name'),
                items: [],
                onChanged: (value) {}),
            title: 'Full Name',
          ),
          FormItem(
            title: "Department",
            child: DropdownButtonFormField(
                hint: Text('Dept'), items: [], onChanged: (value) {}),
          ),
          FormItem(
            title: "Year of study",
            child: DropdownButtonFormField(
                hint: Text('Select year'), items: [], onChanged: (value) {}),
          ),
          GradientButton(
            width: double.infinity,
            label: 'Continue',
            onTap: nextPage,
          )
        ],
      )),
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
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StringStyle.normalTextBold(size: 18),
        ),
        child
      ],
    );
  }
}

import 'dart:developer';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/controller/app/app_contoller.dart';
import 'package:stuedic_app/styles/snackbar__style.dart';
import 'package:stuedic_app/styles/string_styles.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/data/app_db.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';

class ClubSelection extends StatefulWidget {
  const ClubSelection(
      {super.key,
      required this.prowatch,
      required this.proRead,
      required this.nextPage});
  final AppContoller prowatch;
  final AppContoller proRead;
  final Function() nextPage;
  @override
  State<ClubSelection> createState() => _ClubSelectionState();
}

class _ClubSelectionState extends State<ClubSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Select Clubs That Interest You',
                style: StringStyle.topHeading(size: 32),
                softWrap: true,
              ),
              const SizedBox(height: 16),
              Text(
                'Choose from a diverse range of interests that align with your passions and preferences.',
                softWrap: true,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ChipsChoice<String>.multiple(
                value: widget.prowatch.val,
                onChanged: (List<String> selected) {
                  widget.proRead.changeChip(selected);
                },
                choiceItems: C2Choice.listFrom<String, String>(
                  source: AppDb.clubOptions,
                  value: (index, item) => item,
                  label: (index, item) => item,
                ),
                wrapped: true,
                choiceStyle: C2ChipStyle.outlined(
                  borderRadius: BorderRadius.circular(20),
                  borderWidth: 1.5,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  selectedStyle: C2ChipStyle.filled(
                    foregroundColor: ColorConstants.secondaryColor,
                    color: ColorConstants.primaryColor2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GradientButton(
                width: double.infinity,
                isColored: true,
                label: 'Continue',
                onTap: () {
                  if (widget.prowatch.val.isEmpty) {
                    customSnackbar(
                        label: 'Select at least one club', context: context);
                  } else {
                    log('Selected Clubs: ${widget.proRead.val}');
                    widget.nextPage();
                  }
                },
              ),
              const SizedBox(height: 20),
              GradientButton(
                width: double.infinity,
                label: 'MayBeLater',
                onTap: widget.nextPage,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/dialogs/desgination_dialog.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';

class DesignationSelection extends StatelessWidget {
  const DesignationSelection({
    super.key,
    required this.prowatch,
    required this.proRead,
    required this.nextPage,
  });

  final AppContoller prowatch;
  final AppContoller proRead;
  final Function() nextPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: prowatch.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Choose the one that describes you!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Create your username and you can change it later.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ...prowatch.userTypes.map(
              (type) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => proRead.changeRadio(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      gradient: prowatch.selectedUserType == type
                          ? ColorConstants.primaryGradientHorizontal
                          : const LinearGradient(
                              colors: [Colors.white, Colors.white]),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: RadioListTile<String>(
                      title: Text(type),
                      value: type,
                      groupValue: prowatch.selectedUserType,
                      onChanged: (value) => proRead.changeRadio(value!),
                      activeColor: ColorConstants.secondaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            GradientButton(
              width: double.infinity,
              label: 'Continue',
              onTap: () async {
                proRead.onDesiginationContinue(
                    context: context, nextPage: nextPage);
await AppUtils.saveRole(prowatch.selectedUserType);
              },
              isColored: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

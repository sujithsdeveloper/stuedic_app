import 'package:flutter/material.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';
import 'package:stuedic_app/widgets/gradient_button.dart';

class DesiginationSelection extends StatelessWidget {
  const DesiginationSelection({super.key, required this.prowatch, required this.proRead, required this.nextPage});
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
                              Text(
                                'Choose the one that describes you!',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Create your username and you can change it later.',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 24),
                              ...prowatch.userTypes.map(
                                (type) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      proRead.changeRadio(type);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: prowatch.selectedUserType == type
                                            ? ColorConstants.primaryColor2
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: RadioListTile<String>(
                                        title: Text(type),
                                        value: type,
                                        groupValue: prowatch.selectedUserType,
                                        onChanged: (value) {
                                          proRead.changeRadio(value!);
                                        },
                                        activeColor: Colors.black,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Spacer(),
                              Center(
                                child: GradientButton(
                                  width: double.infinity,
                                  label: 'Continue',
                                  onTap: () {
                                    // log("Selected User Type: ${prowatch.selectedUserType}");
                                    nextPage();
                                  },
                                  isColored: true,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      );

  }
}
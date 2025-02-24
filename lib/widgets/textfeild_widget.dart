import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuedic_app/controller/app_contoller.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class TextfieldWidget extends StatelessWidget {
  const TextfieldWidget({
    super.key,
    required this.hint,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.maxLength,
    this.helperText,  this.dismissKeyboardOnTapOutside=false, this.maxline,
  });
  final String hint;
  final bool isPassword;
  final bool dismissKeyboardOnTapOutside;
  final int? maxLength;
  final String? helperText;

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String?)? onChanged;
  final int? maxline;

  @override
  Widget build(BuildContext context) {
    final prowatch = context.watch<AppContoller>();
    final proRead = context.read<AppContoller>();

    // final prowatch=AppUtils.appProvider(context: context);

    return TextFormField(
      maxLines: maxline,
      maxLength: maxLength == null ? null : maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: key,
      onChanged: onChanged,
      onTapOutside:dismissKeyboardOnTapOutside? (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      }:null,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: isPassword ? prowatch.isObscure : false,
      decoration: InputDecoration(
        helperText: helperText == null ? null : helperText,
        hintText: hint,
        helperStyle: TextStyle(color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: ColorConstants.primaryColor2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  proRead.toggleObscure();
                },
                icon: Icon(prowatch.isObscure
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash))
            : null,
      ),
    );
  }
}

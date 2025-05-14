import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

class DropdownWidget<T> extends StatelessWidget {
  const DropdownWidget({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.items,
    this.validator,
    this.value,
  });

  final String hint;
  final String? Function(T?)? validator;
  final Function(T?) onChanged;
  final List<DropdownMenuItem<T>> items;
  final T? value; // <-- add value

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        helperStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: ColorConstants.primaryColor2),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
      ),
      hint: Text(hint),
      items: items,
      onChanged: onChanged,
      value: value, // <-- set value
    );
  }
}

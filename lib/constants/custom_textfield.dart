import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;

  const CustomTextField({super.key, required this.controller, required this.hintText, this.inputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(color: AppColors.textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[850],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

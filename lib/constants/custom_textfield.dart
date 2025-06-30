import 'package:email_checker/Utils/font_styles.dart';
import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final double height;
  final double width;

  const CustomTextField({super.key, required this.controller, required this.hintText, this.inputType = TextInputType.text, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: FTextStyle.normal,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: FTextStyle.normal,
        filled: true,
        // fillColor: Colors.grey[500],
        contentPadding: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

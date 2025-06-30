import 'package:email_checker/Utils/font_styles.dart';
import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_constants.dart';
import '../utils/responsive.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.screenWidth(context),
      height: Responsive.screenHeight(context) * 0.055,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? Colors.black26 :AppColors.brandNewBorder,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: AppColors.brandNewBg,
            strokeWidth: 2,
          ),
        )
            : Text(text, style: FTextStyle.normal),
      ),
    );
  }
}

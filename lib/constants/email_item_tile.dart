import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_constants.dart';

class EmailItemTile extends StatelessWidget {
  final String email;
  final bool isValid;

  const EmailItemTile({super.key, required this.email, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.padding / 2),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(email, style: const TextStyle(color: AppColors.textColor)),
          Icon(isValid ? Icons.check_circle : Icons.cancel, color: isValid ? AppColors.successColor : AppColors.errorColor)
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';
import '../constants/custom_button.dart';
import '../constants/custom_textfield.dart';
import '../utils/responsive.dart';

class SingleEmailScreen extends StatefulWidget {
  const SingleEmailScreen({super.key});

  @override
  State<SingleEmailScreen> createState() => _SingleEmailScreenState();
}

class _SingleEmailScreenState extends State<SingleEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? validationResult;

  void validateEmail() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        validationResult = "Please enter an email.";
      });
      return;
    }

    // Dummy API simulation
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      validationResult = email.contains("@") ? "Email is valid ✅" : "Email is invalid ❌";
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Single Email Check"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              controller: _emailController,
              hintText: "Enter email address",
            ),
            SizedBox(height: height * 0.03),
            CustomButton(
              text: "Validate",
              onPressed: validateEmail,
            ),
            SizedBox(height: height * 0.03),
            if (validationResult != null)
              Text(
                validationResult!,
                style: TextStyle(
                  color: validationResult!.contains("valid") ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

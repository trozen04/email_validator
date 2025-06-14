import 'dart:developer' as developer;

import 'package:email_checker/ApiServices/email_validator_bloc.dart';
import 'package:email_checker/Utils/font_styles.dart';
import 'package:email_checker/Widgets/CustomSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String? warningMessage;
  bool isLoading = false;
  bool isSuccessResponse = false;

  void validateEmail() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        warningMessage = "Please enter an email address.";
      });
      return;
    }

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      setState(() {
        warningMessage = "Please enter a valid email format.";
      });
      return;
    }

    setState(() {
      warningMessage = null;
      validationResult = null;
      isLoading = true;
    });

    context.read<EmailValidatorBloc>().add(EmailValidatorEmailHandler(email: email));
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);

    return BlocListener<EmailValidatorBloc, EmailValidatorState>(
      listener: (context, state) {
        if (state is EmailValidatorLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is EmailValidatorSuccessState) {
          developer.log('success: ${state.response}');
          final result = state.response;
          setState(() {
            isLoading = false;
            validationResult = result;
            isSuccessResponse = true;
            CustomSnackbar.show(context, message: validationResult!, isSuccess: true);
          });
        } else if (state is EmailValidatorErrorState) {
          developer.log('error: ${state.errorMessage}');
          setState(() {
            isLoading = false;
            validationResult = state.errorMessage;
            isSuccessResponse = false;
            CustomSnackbar.show(context, message: validationResult!, isSuccess: false);
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: const Text("Single Email Validator"),
          backgroundColor: AppColors.brandNewBorder,
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
              SizedBox(height: height * 0.015),
              if (warningMessage != null)
                Text(
                  warningMessage!,
                  style: FTextStyle.normal.copyWith(color: Colors.redAccent),
                  textAlign: TextAlign.left,
                ),
              SizedBox(height: height * 0.03),
              CustomButton(
                text: isLoading ? "Validating..." : "Validate Email",
                onPressed: isLoading ? null : validateEmail,
              ),
              SizedBox(height: height * 0.03),
              if (validationResult != null)
                Text(
                  validationResult!,
                  style: FTextStyle.heading.copyWith(
                    color: (isSuccessResponse == true)
                        ? AppColors.brand
                        : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

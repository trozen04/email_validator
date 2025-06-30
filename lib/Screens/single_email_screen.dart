import 'dart:developer' as developer;
import 'package:email_checker/ApiServices/email_validator_bloc.dart';
import 'package:email_checker/Utils/font_styles.dart';
import 'package:email_checker/Widgets/CustomSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Utils/app_colors.dart';
import '../Utils/custom_shadow.dart';
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
  String? validatedEmail;

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
    setState(() {
      validatedEmail = email;
    });
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    CustomSnackbar.show(context, message: "Copied to clipboard!", isSuccess: true);
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);

    return BlocListener<EmailValidatorBloc, EmailValidatorState>(
      listener: (context, state) {
        if (state is EmailValidatorLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is EmailValidatorSuccessState) {
          final result = state.response;
          setState(() {
            isLoading = false;
            validationResult = result;
            isSuccessResponse = true;
            CustomSnackbar.show(context, message: validationResult!, isSuccess: true);
          });
        } else if (state is EmailValidatorErrorState) {

          setState(() {
            isLoading = false;
            validationResult = state.errorMessage;
            isSuccessResponse = false;
            CustomSnackbar.show(context, message: validationResult!, isSuccess: false);
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Single Email Validator", style: FTextStyle.normal),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  SizedBox(width: width * 0.04,),
                  Icon(Icons.arrow_back_ios, color: Colors.white,),
                ],
              )),
          backgroundColor: AppColors.brandNewBorder,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _emailController,
                hintText: "Enter email address",
                height: height,
                width: width,
              ),
              SizedBox(height: height * 0.015),
              if (warningMessage != null)
                Text(
                  warningMessage!,
                  style: FTextStyle.normal.copyWith(color: Colors.redAccent),
                  textAlign: TextAlign.left,
                ),
              SizedBox(height: height * 0.01),
              CustomButton(
                text: "Start Validation",
                isLoading: isLoading,
                onPressed: isLoading ? () {} : validateEmail,
              ),
              SizedBox(height: height * 0.03),

              /// New block showing email + copy button after validation
              if (validatedEmail != null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: width * 0.035),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: CustomShadow.lightShadow,
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          validatedEmail!,
                          style: FTextStyle.normal.copyWith(color: AppColors.brandNewBorder),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.brandNewBorder),
                        onPressed: () => copyToClipboard(validatedEmail!),
                      ),
                    ],
                  ),
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

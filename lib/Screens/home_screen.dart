import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';
import '../Utils/screen_names.dart';
import '../constants/custom_button.dart';
import '../utils/responsive.dart';
import '../utils/navigation_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Validator'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(height * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Upload CSV File',
              onPressed: () {
                Navigator.pushNamed(context, ScreenNames.csvUpload);
              },
            ),
            SizedBox(height: height * 0.04),
            CustomButton(
              text: 'Single Email Check',
              onPressed: () {
                Navigator.pushNamed(context, ScreenNames.singleEmail);
              },
            ),
          ],
        ),
      ),
    );
  }
}

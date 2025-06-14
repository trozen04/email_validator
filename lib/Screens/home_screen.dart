import 'package:email_checker/Utils/image_assets.dart';
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
    double width = Responsive.screenWidth(context);

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text('Email Validator'),
        backgroundColor: AppColors.brandNewBorder,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(height * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(ImageAssets.appIcon, width: width * 0.5),
            SizedBox(height: height * 0.01),
            CustomButton(
              text: 'Upload CSV File',
              onPressed: () {
                Navigator.pushNamed(context, ScreenNames.csvUpload);
              },
            ),
            SizedBox(height: height * 0.03),
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

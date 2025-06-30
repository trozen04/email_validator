import 'package:email_checker/Utils/font_styles.dart';
import 'package:email_checker/Utils/image_assets.dart';
import 'package:flutter/cupertino.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Email Validator', style: FTextStyle.normal,),
        backgroundColor: AppColors.brandNewBorder,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/history'),
            child: Icon(Icons.history, color: Colors.white),
          ),
          SizedBox(width: width * 0.03,)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.1),
                decoration: BoxDecoration(
                  color: AppColors.brandNewBorder,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.mail, color: Colors.white, size: width * 0.25),
                    Text('MailVity', style: FTextStyle.heading),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.03),
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

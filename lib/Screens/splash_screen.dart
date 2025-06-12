import 'package:email_checker/Utils/image_assets.dart';
import 'package:flutter/material.dart';
import '../Utils/screen_names.dart';
import '../utils/responsive.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_constants.dart';
import '../constants/custom_button.dart';
import '../constants/custom_textfield.dart';
import '../utils/navigation_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, ScreenNames.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);

    return Scaffold(
      body: Center(
        child: Image.asset(ImageAssets.appIcon, width: width * 0.6)
      ),
    );
  }
}

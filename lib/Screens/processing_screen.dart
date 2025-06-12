import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';
import '../Utils/screen_names.dart';
import '../utils/responsive.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, ScreenNames.results);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing...'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primaryColor),
            SizedBox(height: height * 0.04),
            const Text(
              'Validating emails, please wait...',
              style: TextStyle(color: AppColors.textColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

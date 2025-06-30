import 'package:flutter/material.dart';
import '../Screens/history_screen.dart';
import '../Utils/screen_names.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/csv_upload_screen.dart';
import '../screens/processing_screen.dart';
import '../screens/result_screen.dart';
import '../screens/single_email_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      ScreenNames.splash: (context) => const SplashScreen(),
      ScreenNames.home: (context) => const HomeScreen(),
      ScreenNames.csvUpload: (context) => const CsvUploadScreen(),
      ScreenNames.processing: (context) => const ProcessingScreen(),
      ScreenNames.results: (context) => const ResultsScreen(),
      ScreenNames.singleEmail: (context) => const SingleEmailScreen(),
      ScreenNames.history:  (context) => const HistoryScreen(),
    };
  }
}
import 'package:flutter/material.dart';
import 'ApiServices/email_validator_bloc.dart';
import 'Utils/app_colors.dart';
import 'Utils/screen_names.dart';
import 'routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const EmailValidatorApp());
}

class EmailValidatorApp extends StatelessWidget {
  const EmailValidatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailValidatorBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Email Validator',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.backgroundColor,
        ),
        initialRoute: ScreenNames.splash,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}

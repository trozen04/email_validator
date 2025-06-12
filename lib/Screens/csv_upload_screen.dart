// screens/csv_upload_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import '../ApiServices/email_validator_bloc.dart';
import '../utils/app_colors.dart';
import '../constants/custom_button.dart';
import '../utils/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/font_styles.dart';

class CsvUploadScreen extends StatefulWidget {
  const CsvUploadScreen({super.key});

  @override
  State<CsvUploadScreen> createState() => _CsvUploadScreenState();
}

class _CsvUploadScreenState extends State<CsvUploadScreen> {
  String? selectedFileName;
  String? filePath;
  bool isProcessing = false;
  List<String> emails = [];

  Future<void> pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      String? pickedFilePath = result.files.single.path;
      if (pickedFilePath != null && pickedFilePath.toLowerCase().endsWith('.csv')) {
        setState(() {
          selectedFileName = result.files.single.name;
          filePath = pickedFilePath;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a valid CSV file.")),
        );
      }
    }
  }

  Future<void> processCsvFile() async {
    if (filePath == null) return;

    setState(() {
      isProcessing = true;
    });

    final input = File(filePath!).openRead();
    final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();

    // Extract emails from the first column (assuming first row is header)
    emails.clear();
    for (int i = 1; i < fields.length; i++) {
      String email = fields[i][0].toString().trim();
      if (email.isNotEmpty) {
        emails.add(email);
      }
    }

    // Dispatch each email one by one to Bloc
    for (String email in emails) {
      context.read<EmailValidatorBloc>().add(EmailValidatorEmailHandler(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload CSV File"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocListener<EmailValidatorBloc, EmailValidatorState>(
        listener: (context, state) {
          if (state is EmailValidatorLoadingState) {
            setState(() {
              isProcessing = true;
            });
          } else if (state is EmailValidatorSuccessState || state is EmailValidatorErrorState) {
            setState(() {
              isProcessing = false;
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.all(height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButton(
                text: "Select CSV File",
                onPressed: pickCsvFile,
              ),
              SizedBox(height: height * 0.03),
              if (selectedFileName != null)
                Text(
                  "Selected File: $selectedFileName",
                  style: FontStyles.normal,
                ),
              SizedBox(height: height * 0.03),
              if (selectedFileName != null)
                CustomButton(
                  text: isProcessing ? "Processing..." : "Start Validation",
                  onPressed: isProcessing ? null : () => processCsvFile(),
                ),

            ],
          ),
        ),
      ),
    );
  }
}


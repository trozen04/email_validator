import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:csv/csv.dart';
import 'package:email_checker/Utils/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ApiServices/email_validator_bloc.dart';
import '../utils/app_colors.dart';
import '../constants/custom_button.dart';
import '../utils/responsive.dart';

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
  List<String> validEmails = [];
  int currentIndex = 0;
  String? processingEmail;

  final List<String> blockedDomains = [
    'domain.org' // <-- You can add more domains here that break your API
  ];

  Future<void> pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      String? pickedFilePath = result.files.single.path;
      if (pickedFilePath != null) {
        setState(() {
          selectedFileName = result.files.single.name;
          filePath = pickedFilePath;
        });

        await extractEmailsFromCsv();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a valid CSV file.")),
        );
      }
    }
  }

  Future<void> extractEmailsFromCsv() async {
    try {
      final input = File(filePath!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter(eol: '\n'))
          .toList();

      developer.log("Parsed CSV data: $fields");

      emails.clear();

      if (fields.isNotEmpty && fields.length == 1) {
        String rawData = fields.first.join();
        List<String> lines = rawData.split(RegExp(r'[\r\n]+'));

        for (String line in lines) {
          final parts = line.split(',');
          for (String part in parts) {
            extractEmailFromText(part);
          }
        }
      } else {
        for (int i = 1; i < fields.length; i++) {
          final row = fields[i];
          for (var cell in row) {
            extractEmailFromText(cell.toString());
          }
        }
      }

      developer.log("Total emails extracted: ${emails.length}");
    } catch (e) {
      developer.log("Error parsing CSV: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error parsing CSV file.")),
      );
    }
  }

  void extractEmailFromText(String text) {
    final RegExp emailRegex = RegExp(
        r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final matches = emailRegex.allMatches(text);
    for (final match in matches) {
      final email = match.group(0);
      if (email != null && !emails.contains(email)) {
        emails.add(email);
      }
    }
  }

  bool isValidEmailFormat(String email) {
    final regex = RegExp(
        r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
    );
    return regex.hasMatch(email);
  }

  bool isBlacklistedDomain(String email) {
    for (String domain in blockedDomains) {
      if (email.toLowerCase().endsWith(domain)) {
        return true;
      }
    }
    return false;
  }

  Future<void> processCsvFile() async {
    if (emails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No emails found to validate.")),
      );
      return;
    }

    setState(() {
      isProcessing = true;
      validEmails.clear();
      currentIndex = 0;
    });

    developer.log("Starting validation for ${emails.length} emails");
    validateNextEmail();
  }

  void validateNextEmail() {
    if (currentIndex >= emails.length) {
      developer.log("All emails processed.");
      setState(() {
        isProcessing = false;
      });
      return;
    }

    String email = emails[currentIndex];
    processingEmail = email;  // SAVE CURRENT EMAIL
    developer.log("Validating: $email");

    if (!isValidEmailFormat(email)) {
      developer.log("Skipped invalid format: $email");
      currentIndex++;
      validateNextEmail();
      return;
    }

    if (isBlacklistedDomain(email)) {
      developer.log("Skipped blacklisted domain: $email");
      currentIndex++;
      validateNextEmail();
      return;
    }

    context.read<EmailValidatorBloc>().add(
      EmailValidatorEmailHandler(email: email),
    );
  }


  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text("Upload CSV File"),
        backgroundColor: AppColors.brandNewBorder,
      ),
      body: BlocListener<EmailValidatorBloc, EmailValidatorState>(
        listener: (context, state) {
          if (state is EmailValidatorSuccessState) {
            final response = state.responseData;
            developer.log("API Response: $response");

            if (response["success"] == 1 &&
                response["is_exist"].toString().toLowerCase() == "true") {
              if (processingEmail != null) {
                validEmails.add(processingEmail!);
              }
            }
            currentIndex++;
            validateNextEmail();
          } else if (state is EmailValidatorErrorState) {
            developer.log("API Error: ${state.errorMessage}");
            currentIndex++;
            validateNextEmail();
          } else if (state is EmailValidatorGatewayError) {
            developer.log('502 error for: $processingEmail');
            currentIndex++;
            validateNextEmail();
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
                Text("Selected File: $selectedFileName", style: FTextStyle.normal),
              SizedBox(height: height * 0.03),
              if (emails.isNotEmpty)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Extracted Emails:"),
                      Expanded(
                        child: ListView.builder(
                          itemCount: emails.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: const Icon(Icons.email, color: Colors.blueAccent),
                            title: Text(emails[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: height * 0.03),
              if (selectedFileName != null)
                CustomButton(
                  text: isProcessing ? "Processing..." : "Start Validation",
                  onPressed: isProcessing ? null : processCsvFile,
                ),
              SizedBox(height: height * 0.03),
              if (validEmails.isNotEmpty)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Valid Emails Found:"),
                      Expanded(
                        child: ListView.builder(
                          itemCount: validEmails.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: const Icon(Icons.check_circle, color: Colors.green),
                            title: Text(validEmails[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

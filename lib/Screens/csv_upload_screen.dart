import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:email_checker/Utils/custom_shadow.dart';
import 'package:email_checker/Utils/font_styles.dart';
import 'package:email_checker/Utils/shared_prefs.dart';
import 'package:email_checker/Widgets/CustomSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../ApiServices/email_validator_bloc.dart';
import '../utils/app_colors.dart';
import '../constants/custom_button.dart';
import '../utils/responsive.dart';

class CsvUploadScreen extends StatefulWidget {
  const CsvUploadScreen({super.key});

  @override
  State<CsvUploadScreen> createState() => _CsvUploadScreenState();
}

class _CsvUploadScreenState extends State<CsvUploadScreen> with TickerProviderStateMixin {
  String? selectedFileName, filePath;
  bool isProcessing = false;
  bool isSaveEnabled = false;
  List<String> emails = [], validEmails = [];
  int currentIndex = 0;
  String? processingEmail;
  Completer<void>? _validationCompleter;

  final blockedDomains = ['domain.org'];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  Future<void> pickCsvFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    if (result != null && result.files.single.path != null) {
      if (listKey.currentState != null && validEmails.isNotEmpty) {
        for (var i = validEmails.length - 1; i >= 0; i--) {
          listKey.currentState!.removeItem(
            i,
                (context, animation) => FadeTransition(opacity: animation, child: const SizedBox.shrink()),
            duration: const Duration(milliseconds: 300),
          );
        }
      }

      setState(() {
        selectedFileName = result.files.single.name;
        filePath = result.files.single.path!;
        validEmails.clear();
        emails.clear();
        currentIndex = 0;
        isSaveEnabled = false;
        isProcessing = false;
      });
      await extractEmailsFromCsv();
    }
  }

  Future<void> extractEmailsFromCsv() async {
    try {
      final input = File(filePath!).openRead();
      final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter(eol: '\n')).toList();

      for (int i = 1; i < fields.length; i++) {
        for (var cell in fields[i]) {
          extractEmailFromText(cell.toString());
        }
      }

      if (emails.isEmpty) {
        CustomSnackbar.show(context, message: "No emails found in the CSV file.", isSuccess: false);
      }
    } catch (e) {
      CustomSnackbar.show(context, message: "Error parsing CSV file: $e", isSuccess: false);
    }
  }

  void extractEmailFromText(String text) {
    final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    for (final match in emailRegex.allMatches(text)) {
      final email = match.group(0);
      if (email != null && !emails.contains(email)) {
        emails.add(email);
      }
    }
  }

  Future<void> processCsvFile() async {
    if (emails.isEmpty) {
      CustomSnackbar.show(context, message: "No emails found in the CSV file.", isSuccess: false);
      return;
    }

    setState(() {
      isProcessing = true;
      validEmails.clear();
      currentIndex = 0;
    });

    validateNextEmail();
  }

  Future<void> validateNextEmail() async {
    if (currentIndex >= emails.length) {
      setState(() {
        isProcessing = false;
        isSaveEnabled = true;
      });
      return;
    }

    processingEmail = emails[currentIndex];

    if (!isValidEmailFormat(processingEmail!) || isBlacklistedDomain(processingEmail!)) {
      currentIndex++;
      await validateNextEmail();
      return;
    }

    _validationCompleter = Completer<void>();

    context.read<EmailValidatorBloc>().add(
      EmailValidatorEmailHandler(email: processingEmail!),
    );

    await _validationCompleter!.future;

    currentIndex++;
    await validateNextEmail();
  }

  bool isValidEmailFormat(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  bool isBlacklistedDomain(String email) {
    return blockedDomains.any((domain) => email.toLowerCase().endsWith(domain));
  }

  Future<void> saveValidEmailsToDownloads() async {
    if (validEmails.isEmpty) {
      CustomSnackbar.show(context, message: "No valid emails found.", isSuccess: false);
      return;
    }

    try {
      final downloadsDir = await getExternalStorageDirectory();
      final fileName = selectedFileName?.replaceAll('.csv', '') ?? 'emails';
      final file = File('${downloadsDir!.path}/trozen_$fileName.txt');

      final content = validEmails.join(', ');
      await file.writeAsString(content);

      await Prefs.addProcessedFile(file.path);
      CustomSnackbar.show(context, message: "Saved to: ${file.path}", isSuccess: true);
    } catch (e) {
      CustomSnackbar.show(context, message: "Error saving file: $e", isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Upload CSV File", style: FTextStyle.normal),
        backgroundColor: AppColors.brandNewBorder,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              SizedBox(width: height * 0.03),
              Icon(Icons.arrow_back_ios, color: Colors.white),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          SizedBox(width: height * 0.03),
        ],
      ),
      body: BlocListener<EmailValidatorBloc, EmailValidatorState>(
        listener: (context, state) {
          if (state is EmailValidatorSuccessState) {
            final response = state.responseData;
            if (response["success"] == 1 && response["is_exist"].toString().toLowerCase() == "true") {
              validEmails.add(processingEmail!);
              listKey.currentState?.insertItem(validEmails.length - 1, duration: const Duration(milliseconds: 400));
            }
            _validationCompleter?.complete();
          } else if (state is EmailValidatorErrorState || state is EmailValidatorGatewayError) {
            _validationCompleter?.complete(); // continue on error
          }
        },
        child: Padding(
          padding: EdgeInsets.all(height * 0.03),
          child: Column(
            children: [
              CustomButton(
                text: isProcessing ? 'Wait' : "Select CSV File",
                onPressed: isProcessing
                    ? () {
                  CustomSnackbar.show(context,
                      message: "Cannot select a new file while validation is in progress.", isSuccess: false);
                }
                    : pickCsvFile,
                isLoading: false,
              ),
              SizedBox(height: height * 0.005),
              if (selectedFileName != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Valid Emails for: ${selectedFileName!.replaceAll('.csv', '')}",
                        style: FTextStyle.normal.copyWith(color: Colors.redAccent),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: AppColors.brandNewBg,
                      ),
                      onPressed: isSaveEnabled ? saveValidEmailsToDownloads : null,
                      child: Text("Save", style: FTextStyle.normal),
                    ),
                  ],
                ),
              SizedBox(height: height * 0.02),
              CustomButton(
                text: "Start Validation",
                isLoading: isProcessing,
                onPressed: isProcessing ? () {} : processCsvFile,
              ),
              SizedBox(height: height * 0.03),
              Expanded(
                child: AnimatedList(
                  key: listKey,
                  initialItemCount: validEmails.length,
                  itemBuilder: (context, index, animation) {
                    if (index >= validEmails.length || index < 0) {
                      return const SizedBox.shrink();
                    }
                    return SlideTransition(
                      position: animation.drive(Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOut))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: CustomListTile(email: validEmails[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String email;
  const CustomListTile({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: CustomShadow.lightShadow,
        border: Border.all(color: Colors.black26),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.brandNew,
          child: Icon(Icons.check, color: Colors.white, size: 18),
        ),
        title: Text(email, style: FTextStyle.normal.copyWith(color: AppColors.brandNewBorder)),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 20, color: AppColors.brandNewBorder),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: email));
            CustomSnackbar.show(context, message: "Email copied: $email", isSuccess: true);
          },
        ),
      ),
    );
  }
}

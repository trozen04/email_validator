import 'dart:developer' as developer;
import 'dart:io';
import 'package:email_checker/Utils/custom_shadow.dart';
import 'package:email_checker/Utils/responsive.dart';
import 'package:email_checker/Utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';
import '../Utils/font_styles.dart';
import '../Widgets/CustomSnackbar.dart';
import '../Widgets/open_file_content.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> files = [];

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  void loadFiles() async {
    files = await Prefs.getProcessedFiles();

    setState(() {});
  }

  void openFileContent(String filePath, double height, double width) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final fileContent = await file.readAsString();
        showDialog(
          context: context,
          builder: (_) => EmailFileContentDialog(
            content: fileContent,
            height: height,
            width: width,
          ),
        );
      } else {
        CustomSnackbar.show(context, message: "File not found: $filePath", isSuccess: false);
      }
    } catch (e) {
      CustomSnackbar.show(context, message: "Error reading file: $e", isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("History", style: FTextStyle.normal),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                SizedBox(width: width * 0.04,),
                const Icon(Icons.arrow_back_ios, color: Colors.white,),
              ],
            )),
        backgroundColor: AppColors.brandNewBorder,
      ),
      body: files.isEmpty
          ? Center(child: Text("No history found", style: FTextStyle.heading))
          : ListView.builder(
        padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.04),
        itemCount: files.length,
        itemBuilder: (context, index) {
          String filename = files[index].split("/").last;
          return CustomHistoryListTile(
            filename: filename,
            onTap: () => openFileContent(files[index], height, width),
            height: height,
            width: width,
          );
        },
      ),
    );
  }
}

class CustomHistoryListTile extends StatelessWidget {
  final String filename;
  final VoidCallback onTap;
  final double width;
  final double height;

  const CustomHistoryListTile({super.key, required this.filename, required this.onTap, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.brandNewBorder,
        boxShadow: CustomShadow.lightShadow,
        border: Border.all(color: Colors.black12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: height * 0.005, horizontal: width * 0.04),
      title: Text(filename, style: FTextStyle.normal),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white),
        onTap: onTap,
      ),
    );
  }
}

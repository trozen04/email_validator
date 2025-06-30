import 'package:email_checker/Utils/app_colors.dart';
import 'package:email_checker/Utils/font_styles.dart';
import 'package:email_checker/Widgets/share_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'common_widgets.dart';
import '../Widgets/CustomSnackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmailFileContentDialog extends StatelessWidget {
  final String content;
  final double height;
  final double width;

  const EmailFileContentDialog({
    Key? key,
    required this.content,
    required this.height,
    required this.width,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(vertical: height * 0.005, horizontal: width * 0.04),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.04),
        constraints: BoxConstraints(maxHeight: height * 0.65),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "File Content",
                  style: FTextStyle.heading.copyWith(color: AppColors.brandNewBorder),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            DashedDivider(color: AppColors.brandNew),
            SizedBox(height: height * 0.01),
            // Email Content
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: FTextStyle.normal.copyWith(color: AppColors.brandNew),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: content));
                      CustomSnackbar.show(context, message: "All emails copied!", isSuccess: false);
                    },
                    icon: const Icon(Icons.copy, color: Colors.white, size: 18),
                    label: Text("Copy All Emails", style: FTextStyle.normal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandNewBorder,
                      padding: EdgeInsets.symmetric(vertical: height * 0.01),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => SharePopup(content: content),
                      );
                    },
                    icon: const Icon(Icons.share, color: Colors.white, size: 18),
                    label: Text("Share", style: FTextStyle.normal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandNew,
                      padding: EdgeInsets.symmetric(vertical: height * 0.01),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CustomSnackbar.dart';

class SharePopup extends StatelessWidget {
  final String content;

  const SharePopup({super.key, required this.content});

  Future<void> _shareFile(BuildContext context, String appName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/emails.txt').create();
      await file.writeAsString(content);

      if (Platform.isAndroid) {
        String? packageName;
        switch (appName) {
          case 'WhatsApp':
            packageName = 'com.whatsapp';
            break;
          case 'Facebook':
            packageName = 'com.facebook.katana';
            break;
          case 'Instagram':
            packageName = 'com.instagram.android';
            break;
          case 'More':
            await Share.shareXFiles(
              [XFile(file.path)],
              text: 'Here are the emails via QREviX',
            );

            return;
        }

        if (packageName != null) {
          final intent = AndroidIntent(
            action: 'action_send',
            package: packageName,
            type: 'text/plain',
            arguments: {
              'android.intent.extra.STREAM': file.path,
              'android.intent.extra.TEXT': 'Here are the emails via QREviX',
            },
          );
          await intent.launch().catchError((e) {
            CustomSnackbar.show(context,
                message: '$appName not installed!', isSuccess: false);
            return e;
          });
        }
      } else {
        // iOS or other platforms: use share_plus
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Here are the emails via QREviX',
        );
      }
    } catch (e) {
      CustomSnackbar.show(context, message: 'Something went wrong!', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 360 ? 22.0 : 28.0;
    final avatarRadius = screenWidth < 360 ? 24.0 : 30.0;
    final fontSize = screenWidth < 360 ? 11.0 : 13.0;
    final spacing = screenWidth < 360 ? 16.0 : 24.0;

    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(spacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareIcon(
                  context,
                  label: 'WhatsApp',
                  icon: FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                  iconSize: iconSize,
                  avatarRadius: avatarRadius,
                  fontSize: fontSize,
                ),
                _buildShareIcon(
                  context,
                  label: 'Facebook',
                  icon: FontAwesomeIcons.facebook,
                  color: Colors.blue,
                  iconSize: iconSize,
                  avatarRadius: avatarRadius,
                  fontSize: fontSize,
                ),
                _buildShareIcon(
                  context,
                  label: 'Instagram',
                  icon: FontAwesomeIcons.instagram,
                  color: Colors.purple,
                  iconSize: iconSize,
                  avatarRadius: avatarRadius,
                  fontSize: fontSize,
                ),
                _buildShareIcon(
                  context,
                  label: 'More',
                  icon: Icons.more_horiz,
                  color: Colors.grey,
                  iconSize: iconSize,
                  avatarRadius: avatarRadius,
                  fontSize: fontSize,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildShareIcon(
      BuildContext context, {
        required String label,
        required IconData icon,
        required Color color,
        required double iconSize,
        required double avatarRadius,
        required double fontSize,
      }) {
    return GestureDetector(
      onTap: () => _shareFile(context, label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            radius: avatarRadius,
            child: Icon(icon, color: color, size: iconSize),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: fontSize)),
        ],
      ),
    );
  }
}
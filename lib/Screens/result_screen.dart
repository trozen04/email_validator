import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';
import '../constants/email_item_tile.dart';
import '../utils/responsive.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);

    // Dummy data (in real case, this should be fetched from API response)
    List<Map<String, dynamic>> results = [
      {"email": "user1@example.com", "isValid": true},
      {"email": "user2@example.com", "isValid": false},
      {"email": "user3@example.com", "isValid": true},
      {"email": "user4@example.com", "isValid": false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation Results'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(height * 0.02),
        child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return EmailItemTile(
              email: item['email'],
              isValid: item['isValid'],
            );
          },
        ),
      ),
    );
  }
}

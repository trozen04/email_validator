import 'package:flutter/material.dart';

class Responsive {
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
}
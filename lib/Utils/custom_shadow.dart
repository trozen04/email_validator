import 'package:flutter/material.dart';

class CustomShadow {
  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      spreadRadius: 1,
      blurRadius: 8,
      offset: const Offset(2, 4), // x, y
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      spreadRadius: 2,
      blurRadius: 12,
      offset: const Offset(4, 6),
    ),
  ];

  static List<BoxShadow> heavyShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      spreadRadius: 3,
      blurRadius: 16,
      offset: const Offset(6, 8),
    ),
  ];

}

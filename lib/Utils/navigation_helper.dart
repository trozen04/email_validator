import 'package:flutter/material.dart';

class NavigationHelper {
  static void navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    ));
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}

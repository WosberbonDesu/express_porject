import 'package:flutter/material.dart';

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

navigateToPage(BuildContext context, Widget page) {
  Navigator.push(context, createRoute(page));
}

navigatePushAndRemove(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(context, createRoute(page), (route) => false);
}

navigatePop(BuildContext context) {
  Navigator.pop(context);
}

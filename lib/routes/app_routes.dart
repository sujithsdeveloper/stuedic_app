import 'package:flutter/material.dart';

class AppRoutes {
  static Route createRoute(Widget tranWidget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => tranWidget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route leftNavigateRoute(Widget tranWidget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => tranWidget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static void push(BuildContext context, Widget newScreen) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => newScreen,
        ));
  }

  static void pushReplacement(BuildContext context, Widget newScreen) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => newScreen,
        ));
  }

  static void pushAndRemoveUntil(BuildContext context, Widget newScreen) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => newScreen,
        ),
        (route) => false);
  }
}

//How to use

//to navigate from a screen to NewScreen
// AppRoutes.push(context, NewScreen());
// AppRoutes.pushReplacement(context, NewScreen());
// AppRoutes.pushAndRemoveUntil(context, NewScreen());

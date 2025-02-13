import 'package:flutter/material.dart';

class GlobalFunctions {
  static bool changeValue(bool value) {
    value = !value;
    return value;
  }
}

class ExpandPageRoute extends PageRouteBuilder {
  final Widget page;

  ExpandPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 100),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Align(
              alignment: Alignment.centerRight,
              child: SizeTransition(
                sizeFactor: animation,

                axis: Axis.horizontal,
                axisAlignment: -1.0, // ✅ Sola doğru büyüme efekti
                child: child,
              ),
            );
          },
        );
}

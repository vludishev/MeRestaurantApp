import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder<dynamic> {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({
    required this.child,
    required this.direction,
  }) : super(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(begin: getBeginOffset(), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease))
            .animate(animation),
        child: child,
      );

  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }
}

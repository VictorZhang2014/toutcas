import 'package:flutter/material.dart';

enum PushAnimateType {
  none,
  leftToRight,
  centerBounce,
}

class PushAnimation { 
  
  static void push(BuildContext context, PushAnimateType animateType, Widget page) {
    if (animateType == PushAnimateType.leftToRight) {
      Navigator.of(context).push(animateRouteFromLeftToRight(page));
    } else if (animateType == PushAnimateType.centerBounce) {
      Navigator.of(context).push(animateCenterBounceRoute(page));
    }
  }

  static Route animateRouteFromLeftToRight(Widget destination) {
    return PageRouteBuilder( 
      pageBuilder: (context, animation, secondaryAnimation) => destination, 
      transitionDuration: const Duration(milliseconds: 300), 
      opaque: false,
      transitionsBuilder: (context, animation, secondaryAnimation, child) { 
        const begin = Offset(-1.0, 0.0);  
        const end = Offset.zero;          
        const curve = Curves.easeInCubic; 
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve)); 
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  } 

  static Route animateCenterBounceRoute(Widget destination) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionDuration: const Duration(milliseconds: 600),
      opaque: false,  
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var scaleTween = Tween<double>(begin: 0.0, end: 1.0);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut, 
        );
        return ScaleTransition(
          scale: scaleTween.animate(curvedAnimation),
          child: child, 
        );
      },
    );
  }


}
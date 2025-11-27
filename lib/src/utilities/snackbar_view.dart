import 'package:flutter/material.dart';

class SnackbarView {
  
  static void error(BuildContext context, String message) { 
    final snackBar = SnackBar( 
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ), 
      backgroundColor: Colors.red.shade700,  
      duration: const Duration(seconds: 3),  
      behavior: SnackBarBehavior.floating,  
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () { 
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ); 
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
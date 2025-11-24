import 'dart:io';
import 'package:flutter/material.dart'; 
import 'package:toutcas/src/app.dart'; 
import 'package:window_manager/window_manager.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
 
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1350, 800),
      minimumSize: Size(500, 450),
      center: true,
      backgroundColor: Colors.white,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    ); 
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } 
    ;
  runApp(ToutCasApp()); 
}


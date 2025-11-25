import 'package:flutter/material.dart';


class WebTabData {  
  int id;
  String url = "";
  String title = "New Tab";
  String? logo = "";
  Widget? pageInstance; // HomeContentDefaultView | WebBrowserView
  bool pageHidden = false;
  Widget? chatInstance;
  bool canBack = false;
  bool canForward = false;
  String htmlcode = "";
  WebTabData({required this.id, required this.url, required this.title});
}
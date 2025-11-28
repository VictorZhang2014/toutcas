import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class BasicConfig extends ChangeNotifier {  
  
  static final BasicConfig _instance = BasicConfig._();
  factory BasicConfig() => _instance;
  BasicConfig._();

  Future<void> init() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); 
    
    appTheme = prefs.getString("appTheme") ?? 'Light'; 
    appLanguageCode = prefs.getString("appLanguageCode") ?? 'en'; 

    appAIModel = prefs.getString("appAIModel") ?? appAIModel; 
    burnedSeconds = prefs.getInt("burnedSeconds") ?? burnedSeconds; 
  }

  String appTheme = 'Light'; 

  void toggleTheme(String theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); 
    appTheme = theme; 
    await prefs.setString("appTheme", appTheme);
    notifyListeners();
  }

  String appLanguageCode = 'en'; 

  void changeLanguage(String code) async {
    if (appLanguageCode == code) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    appLanguageCode = code;
    await prefs.setString("appLanguageCode", code);
    notifyListeners();
  } 

  Map<String, String> getSupportedLanguages() {
    return {
      'en': 'English', 
      'fr': 'Français',
      'zh': '简体中文', 
      'zh_hant': '繁體中文', 
    };
  }

  String getCodeByLanguage(String lang) { 
    return getSupportedLanguages().entries
      .singleWhere((entry) => entry.value == lang, 
      orElse: () => MapEntry('en', 'English')).key;
  }


  String appAIModel = 'openai/gpt-oss-120b:novita'; 
  void changeModel(String model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); 
    appAIModel = model; 
    await prefs.setString("appAIModel", appAIModel);
    notifyListeners();
  }

  int burnedSeconds = 30; // 30 minutes
  void changeBurnedSeconds(int s) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); 
    burnedSeconds = s; 
    await prefs.setInt("burnedSeconds", burnedSeconds);
    notifyListeners();
  }

}
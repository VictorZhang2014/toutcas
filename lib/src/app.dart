import 'package:flutter/material.dart';  
import 'package:flutter_localizations/flutter_localizations.dart';
import 'states/basic_config.dart';
import 'views/home_view.dart';    
import 'localization/app_localizations.dart'; 

class ToutCasApp extends StatelessWidget { 
  ToutCasApp({
    super.key
  }) {
    BasicConfig().init();
  }

  @override
  Widget build(BuildContext context) {    
    final settings = BasicConfig(); 
    Size windowSize = MediaQuery.of(context).size;    
    return ListenableBuilder(
      listenable: settings,
      builder: (context, child) { 
        return MaterialApp( 
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: settings.appLanguageCode == "zh_hant" ? 
            const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant') : 
            Locale(settings.appLanguageCode), 
          supportedLocales: AppLocalizations.supportedLocales, 
          onGenerateTitle: (BuildContext context) => "ToutCas",

          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: settings.appTheme == 'dark' ? ThemeMode.dark : ThemeMode.light,

          onGenerateRoute: (RouteSettings rs) { 
            return MaterialPageRoute(
              settings: rs, 
              builder: (BuildContext context) { 
                switch (rs.name) { 
                  default:
                    return HomeView(windowSize: windowSize);
                }
              },
            );
          }, 
        );
      },
    );
  }

}

import 'package:flutter/material.dart';
import 'package:toutcas/src/localization/app_localizations.dart';
import 'package:toutcas/src/states/basic_config.dart';

class SettingCategory {
  final String title;
  final IconData icon;
  final Widget detailsWidget;

  const SettingCategory(this.title, this.icon, this.detailsWidget);
}

class SettingsView extends StatefulWidget {
  final int tabIndex;
  const SettingsView({super.key, this.tabIndex = 0});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> { 
  final List<SettingCategory> _categories = [
    const SettingCategory('General', Icons.settings_outlined, SettingsForGeneralPanel()),
    SettingCategory('LLMs', Icons.bubble_chart_rounded, SettingsForLLMsPanel()),
    const SettingCategory('About', Icons.info_outline, SettingsForAboutPanel()), 
  ];

  int _selectedIndex = 0;  

  Size currentSize = Size.zero;
  bool _isClosing = false;
  bool _isFadedIn = false; 
  final Color startColor = Colors.transparent;
  final Color endColor = Colors.black.withAlpha(15);

  @override
  void initState() {
    super.initState(); 
    _selectedIndex = widget.tabIndex >= 0 && widget.tabIndex < _categories.length ? widget.tabIndex : 0;
    Future.microtask(() {
      setState(() {
        _isFadedIn = true;
      });
    });
  }

  @override
  void dispose() { 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentSize = MediaQuery.of(context).size; 
    final String currentTitle = _categories[_selectedIndex].title;
    double maxWidth = currentSize.width / 2;
    double maxheight = currentSize.height / 2; 
    if (currentSize.width < 700) {
      maxWidth = 500;
    }
    if (currentSize.height < 500) {
      maxheight = 420;
    }
    final centerContainer = Center(
      child: Container(
        width: maxWidth,
        height: maxheight, 
        decoration: BoxDecoration( 
          border: Border.all(
            color: Colors.grey.shade300, 
            width: 1.0, 
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            // Left Menu Panel
            SizedBox(
              width: maxWidth * 0.3 < 180 ? 180 : maxWidth * 0.3, 
              child: Container( 
                decoration: BoxDecoration(  
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.grey.shade100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MouseRegion( 
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => closePopup(),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.close, size: 18),
                        ),
                      ), 
                    ), 
                    Expanded(
                      child: ListView.builder(
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = index == _selectedIndex; 
                          return ListTile(
                            leading: Icon(category.icon, size: 20, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                            title: Text(
                              getLocalizedTitle(category.title),
                              style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                            ), 
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),  
            // Right Panel
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24.0), 
                width: maxWidth * 0.69 < 270 ? 270 : maxWidth * 0.69, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ 
                    Text(
                      getLocalizedTitle(currentTitle), 
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold ),
                    ),
                    const Divider(height: 32.0), 
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250), 
                        child: _categories[_selectedIndex].detailsWidget,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), 
    );  
    final animation = Stack(
      children: [
        if (!_isClosing) AnimatedContainer( 
          color: _isFadedIn ? endColor : startColor,
          duration: const Duration(milliseconds: 750),  
          curve: Curves.easeInOut,  
          child: SizedBox(
            width: currentSize.width,
            height: currentSize.height,
          ),
        ), 
        centerContainer, 
      ],
    );
    return Scaffold(backgroundColor: Colors.transparent, body: animation);
  }

  String getLocalizedTitle(String t) {
    if (t == "General") {
      return AppLocalizations.of(context)!.general; 
    } else if (t == "About") {
      return AppLocalizations.of(context)!.about;
    }
    return t;
  }

  void closePopup() {
    setState(() {
      _isClosing = true;
    });
    Navigator.pop(context); 
  }

}



class SettingsForGeneralPanel extends StatefulWidget {
  const SettingsForGeneralPanel({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsForGeneralPanelState();
}

class _SettingsForGeneralPanelState extends State<SettingsForGeneralPanel> {

  final List<String> appearanceList = ['System', 'Light', 'Dark'];  
  final List<int> burnedSecondsList = [30, 60, 120];  

  @override
  void initState() { 
    super.initState(); 
  }

  @override
  Widget build(BuildContext context) {
    final settings = BasicConfig(); 
    final languages = settings.getSupportedLanguages(); 
    return ListenableBuilder(
      listenable: settings,
      builder: (context, child) {
         return Center(
          child: Column(
            children: [  
              SizedBox(height: 10),
              DropdownButtonFormField<String>( 
                initialValue: settings.appTheme,  
                onChanged: (String? newValue) {
                  settings.toggleTheme(newValue ?? 'Light'); 
                }, 
                items: appearanceList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                  );
                }).toList(), 
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.appearance,  
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                ),
                isExpanded: true,   
              ), 
              SizedBox(height: 30),
              DropdownButtonFormField<String>( 
                initialValue: languages[settings.appLanguageCode],  
                onChanged: (String? newValue) {
                  final c = settings.getCodeByLanguage(newValue ?? 'English');
                  settings.changeLanguage(c);
                }, 
                items: languages.values
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                  );
                }).toList(), 
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.language,  
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                ), 
                isExpanded: true,  
              ), 
              SizedBox(height: 30),
              DropdownButtonFormField<String>( 
                initialValue: "${settings.burnedSeconds}",  
                onChanged: (String? newValue) { 
                  final s = int.parse(newValue ?? "30"); 
                  settings.changeBurnedSeconds(s);
                }, 
                items: burnedSecondsList
                    .map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text("$value minutes", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                  );
                }).toList(), 
                decoration: InputDecoration(
                  labelText: "Seconds for Burn-After-Use",  
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                ),
                isExpanded: true,   
              ), 
            ],
          ),
        );
      },
    );
  }

}


class SettingsForLLMsPanel extends StatelessWidget {
  SettingsForLLMsPanel({super.key});

  List<Map<String, String>> availableLLMs = [
    {'name': 'OpenAI', 'model': 'openai/gpt-oss-120b:novita'},
    {'name': 'DeepSeek', 'model': 'deepseek-ai/DeepSeek-V3.2-Exp:novita'},
    {'name': 'Mistral AI', 'model': 'mistralai/Mistral-7B-Instruct-v0.2:featherless-ai'},
  ];

  @override
  Widget build(BuildContext context) {
    final settings = BasicConfig(); 
    return ListenableBuilder(
      listenable: settings,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            ...List.generate( 
              availableLLMs.length,
              (index) {
                final llm = availableLLMs[index];
                return GestureDetector(
                  child: ListTile( 
                    leading: Icon(Icons.bubble_chart_rounded, size: 30),
                    title: Text(llm['name']!),
                    subtitle: Text(
                      '${AppLocalizations.of(context)!.model}: ${llm['model']}', 
                      style: TextStyle(
                        fontSize: 12, 
                      ),
                    ),
                    trailing: settings.appAIModel == llm['model']
                        ? Icon(Icons.check_circle_outline, color: Colors.green)
                        : null,
                  ),
                  onTap: () {
                    settings.changeModel(llm['model']!);  
                  },
                );
              },
            ), 
          ], 
        );
      },
    );
  }

} 

class SettingsForAboutPanel extends StatelessWidget {
  const SettingsForAboutPanel({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${AppLocalizations.of(context)!.appName}: ToutCas'),
          Text('${AppLocalizations.of(context)!.slogan}: En tout cas, ça fonctionne toujours.'),
          Text('${AppLocalizations.of(context)!.version}: v1.0.1+1'),
        ],
      ),
    ),
  );

} 
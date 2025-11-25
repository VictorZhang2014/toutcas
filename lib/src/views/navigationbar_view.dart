import 'package:flutter/material.dart'; 
import 'package:toutcas/src/models/web_tabdata.dart';
import 'package:toutcas/src/views/subviews/button_hover.dart';
import 'package:toutcas/src/views/subviews/input_url_view.dart';
import 'package:toutcas/src/localization/app_localizations.dart';

typedef OnChatWithToutCas = void Function(bool open, int index);

class NavigationBarView extends StatefulWidget {
  final List<WebTabData> webTabs;
  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<int> onCloseTab;
  final ValueGetter<bool> onStateToLeftMenu; 
  final ValueSetter<String> onEventSearchText; 
  final VoidCallback onNewTab;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onRefresh;
  final OnChatWithToutCas onChatWithToutCas;

  const NavigationBarView({
    super.key,
    required this.webTabs,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.onCloseTab,
    required this.onStateToLeftMenu,
    required this.onEventSearchText,
    required this.onNewTab,
    required this.onBack,
    required this.onForward,
    required this.onRefresh,
    required this.onChatWithToutCas
  });

  @override
  State<StatefulWidget> createState() => _NavigationBarViewState();

}

class _NavigationBarViewState extends State<NavigationBarView> {

  bool isLeftMenuOpened = false;

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
    final webTab = widget.webTabs[widget.selectedTabIndex];
    return Container( 
      height: 86,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),  
        border: Border(
          bottom: BorderSide(color: Colors.grey[400]!, width: 0.5),
        ),
      ),
      child: Column( 
        children: [ 
          Container(
            color: Colors.grey[200],
            child: Row(
              children: [ 
                const SizedBox(width: 70), 
                Expanded(
                  child: Row( 
                    children: List.generate(widget.webTabs.length, (index) {
                      return Visibility(
                        visible: !widget.webTabs[index].pageHidden,
                        child: Flexible(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: TabButton(
                              title: getUpdatedLabel(widget.webTabs[index].title),
                              logoUrl: widget.webTabs[index].logo,
                              isSelected: index == widget.selectedTabIndex,
                              onTap: () => handleTabSelected(index),
                              onClose: () => widget.onCloseTab(index),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ), 
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: widget.onNewTab,
                  splashRadius: 20,
                  tooltip: AppLocalizations.of(context)!.newTab,
                ),
                const SizedBox(width: 8),  
              ],
            ),
          ),  
          Row(
            children: [
              Container(  
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0), 
                height: 45,
                child: Wrap(
                  children: [ 
                    IconButtonHover(icon: isLeftMenuOpened ? Icons.menu_open_rounded : Icons.menu_rounded, enabled: true, iconSize: 22, onPressed: () {
                      bool r = widget.onStateToLeftMenu();
                      isLeftMenuOpened = r;
                    }), 
                    IconButtonHover(icon: Icons.arrow_back_ios_rounded, enabled: webTab.canBack, iconSize: 16, onPressed: widget.onBack), 
                    IconButtonHover(icon: Icons.arrow_forward_ios_rounded, enabled: webTab.canForward, iconSize: 16, onPressed: widget.onForward), 
                    IconButtonHover(icon: Icons.refresh_rounded, enabled:  webTab.url.isNotEmpty, iconSize: 18, onPressed: widget.onRefresh),
                  ],
                ),
              ), 
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 600, 
                    ),
                    child: InputURLView(
                      initialValue: widget.webTabs[widget.selectedTabIndex].url,
                      onEnterPressed: (String searchText) { 
                        widget.onEventSearchText(searchText);
                      },
                    ),
                  ),
                ),
              ),
              Container(  
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0), 
                height: 45,
                child: Wrap(
                  children: [ 
                    webTab.chatInstance == null ?
                    IconTextButtonHover(
                      icon: Icons.assistant_rounded, 
                      text: AppLocalizations.of(context)!.askToutCas, 
                      enabled: webTab.url.isNotEmpty, 
                      onPressed: () => widget.onChatWithToutCas(webTab.url.isNotEmpty, widget.selectedTabIndex),
                    ) 
                    : IconTextButtonHover(
                      icon: Icons.local_fire_department_rounded, 
                      text: AppLocalizations.of(context)!.burn, 
                      iconColor: Colors.red,
                      enabled: true, 
                      onPressed: () => widget.onChatWithToutCas(false, widget.selectedTabIndex),
                    ),  
                  ],
                ),
              ), 
            ],
          ),
        ],
      ),
    );
  }

  String getUpdatedLabel(String t) {
    if (t == "New Tab") {
      return AppLocalizations.of(context)?.newTab ?? "New Tab";
    }  
    return t; 
  }

  void handleTabSelected(int index) {
    widget.onTabSelected(index);
    // todo
  }
}


class TabButton extends StatelessWidget {
  final String title;
  final String? logoUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const TabButton({
    super.key,
    required this.title,
    this.logoUrl,
    required this.isSelected,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) { 
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.grey[350],
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 40, 
        // constraints: const BoxConstraints(maxWidth: 200), 
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[200], 
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ 
              Expanded(
                child: Wrap(
                  children: [ 
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: logoUrl != null && logoUrl!.isNotEmpty ? Image.network(
                        logoUrl!,
                        width: 16,
                        height: 16,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.public, size: 16, color: Colors.grey);
                        },
                      ) : const Icon(Icons.public, size: 16, color: Colors.grey),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 135),  
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4), 
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(12),
                  // splashRadius: 12,
                  hoverColor: Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }
}


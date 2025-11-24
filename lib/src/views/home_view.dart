import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toutcas/src/utilities/url_util.dart';
import 'package:toutcas/src/views/llm_chatview.dart';
import 'package:toutcas/src/views/home_content_default_view.dart';
import 'package:toutcas/src/views/navigationbar_view.dart';
import 'package:toutcas/src/views/settings_view.dart';
import 'package:toutcas/src/views/subviews/push_animation.dart';
import 'package:toutcas/src/views/web_browser_view.dart';
import 'package:toutcas/src/localization/app_localizations.dart';

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
  WebTabData({required this.id, required this.url, required this.title});
}


class HomeView extends StatefulWidget {
  final Size windowSize;
  const HomeView({super.key, required this.windowSize});

  static const routeName = '/home_view'; 

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> { 
 
  List<WebTabData> webTabs = [];  
  int autoid = 0;
  int selectedTabIndex = 0;  
  int lastSelectedTabIndex = 0;   

  bool _isLeftMenuOpened = false;
  bool _isLeftMenuTextShown = false;
  LeftMenuConfig leftMenuConfig = LeftMenuConfig();
 
  Size currentSize = Size.zero;
  bool _isHiddenAskToutCas = true; 
  
  double _leftWebWidthRatio = 0.8;   
  final double dividerWidth = 3;
  static const double _minWebWidthRatio = 0.50; 
  static const double _maxWebWidthRatio = 0.8;  

  @override
  void initState() { 
    super.initState();  
    createNewTab(); 
  } 

  void _onPanUpdate(DragUpdateDetails details, double totalWidth) {
    setState(() { 
      final double newWidth = (totalWidth * _leftWebWidthRatio) + details.delta.dx;
      double newRatio = newWidth / totalWidth; 
      // Clamp the ratio itself (always between 50% and 85%)
      _leftWebWidthRatio = newRatio.clamp(
        _minWebWidthRatio,
        _maxWebWidthRatio,
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {  
    currentSize = MediaQuery.of(context).size;   
    double leftMenuWidth = _isLeftMenuOpened ? leftMenuConfig.maxWidth : leftMenuConfig.minWidth;
    double leftWebWidth = currentSize.width * _leftWebWidthRatio;
    if (_isHiddenAskToutCas) leftWebWidth = currentSize.width;    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          NavigationBarView(
            webTabs: webTabs,
            selectedTabIndex: selectedTabIndex,
            onTabSelected: (index) {
              lastSelectedTabIndex = selectedTabIndex;
              setState(() {
                selectedTabIndex = index;
              });  
            },
            onCloseTab: (index) {    
              webTabs[index].pageHidden = true; 
              webTabs[index].chatInstance = Container();
              webTabs[index].pageInstance = Container();
              selectedTabIndex = lastSelectedTabIndex; 
              int allHidden = webTabs.where((e) => e.pageHidden).length;
              if (allHidden == webTabs.length) {
                webTabs.clear();
                selectedTabIndex = 0;
                createNewTab();
              } else if (webTabs.length - allHidden == 1) {
                selectedTabIndex = 0;
              }
              setState(() {});   
            },
            onStateToLeftMenu: () {
              _isLeftMenuOpened = !_isLeftMenuOpened;
              setState(() {});
              if (!_isLeftMenuTextShown) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    _isLeftMenuTextShown = true;
                  });
                }); 
              } else {
                _isLeftMenuTextShown = false;
              }
              return _isLeftMenuOpened;
            },
            onEventSearchText: (String searchText) { 
              refreshWithKeyword(searchText);
            },
            onNewTab: () {
              createNewTab();
              setState(() { 
                selectedTabIndex = webTabs.length - 1;
              });
            },
            onBack: () => handlePageStatus("back"),
            onForward: () => handlePageStatus("forward"),
            onRefresh: () => handlePageStatus("refresh"),
            onChatWithToutCas: (bool enabled, int sIndex) {
              // if (!enabled) return; // No retention of state when closing the chat
              setState(() {
                _isHiddenAskToutCas = !_isHiddenAskToutCas;
              });  
              webTabs[selectedTabIndex].chatInstance = _isHiddenAskToutCas ? null : LLMChatView(url: webTabs[sIndex].url); 
            },
          ),  
          Container(
            width: currentSize.width,
            height: currentSize.height - 86,
            color: Colors.transparent,
            child: Row(
              children: [   
                AnimatedContainer(
                  width: leftMenuWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(
                      right: BorderSide(color: Colors.grey[400]!, width: 0.5),
                    ),
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ...List.generate(leftMenuConfig.items.length - 1, (index) { 
                        return _buildLeftMenuItem(index);
                      }),
                      const Spacer(),
                      _buildLeftMenuItem(leftMenuConfig.items.length - 1),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),  
                const VerticalDivider(thickness: 1, width: 0.5),  
                Expanded( 
                  child: IndexedStack(
                    index: selectedTabIndex,
                    children: webTabs.map((entry) {  
                      return KeyedSubtree(
                        key: ValueKey(entry.pageInstance!.key),  
                        child: Visibility(
                          visible: !entry.pageHidden,
                          child: Row( 
                            children: [
                              Expanded( 
                                child: SizedBox(
                                  width: leftWebWidth, 
                                  child: entry.pageInstance!,
                                ),
                              ), 
                              if (!_isHiddenAskToutCas)
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent, 
                                  onPanUpdate: (details) => _onPanUpdate(
                                    details, 
                                    leftWebWidth,
                                  ),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.resizeLeftRight,  
                                    child: Container(
                                      width: dividerWidth,
                                      color: Colors.grey[300]!, 
                                    ),
                                  ),
                                ), 
                              if (webTabs[selectedTabIndex].chatInstance != null) 
                                SizedBox(
                                  width: _isHiddenAskToutCas ? 0.5 : currentSize.width - leftWebWidth,
                                  child: webTabs[selectedTabIndex].chatInstance!,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList()
                  ),
                ),  
              ],
            ), 
          ),
        ],
      ),
    );
  }

  Widget _buildLeftMenuItem(int index) {
    return MouseRegion(
      onEnter: (_) => setState(() => leftMenuConfig.hoveredIndex = index),
      onExit: (_) => setState(() => leftMenuConfig.hoveredIndex = null),
      cursor: SystemMouseCursors.click,
        child: Container(
          padding: _isLeftMenuOpened ? const EdgeInsets.symmetric(vertical: 8, horizontal: 16) :  EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: leftMenuConfig.hoveredIndex == index 
                ? Colors.grey[300]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ), 
          width: _isLeftMenuOpened ? leftMenuConfig.maxWidth - 10 : leftMenuConfig.minWidth - 6,  
          child: GestureDetector(  
            onTap: () { 
              if (leftMenuConfig.items[index].type == "new_chat") {
                createNewTab();
                setState(() { 
                  selectedTabIndex = webTabs.length - 1;
                });
              } else if (leftMenuConfig.items[index].type == "settings") {
                PushAnimation.push(context, PushAnimateType.centerBounce, const SettingsView()); 
              }
            },
            child: Wrap(
              children: [
                Icon(leftMenuConfig.items[index].icon, size: 17),
                const SizedBox(width: 12),
                if (_isLeftMenuTextShown) Text(getUpdatedLabel(leftMenuConfig.items[index].label), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      );
  }

  void createNewTab({String newWindowWithUrl = ""}) {  
    autoid++;
    webTabs.add(WebTabData(id: autoid, url: "", title: "New Tab"));
    if (newWindowWithUrl.isNotEmpty && newWindowWithUrl.length > 5) { 
      int currentIndex = webTabs.length - 1; 
      webTabs.last.pageInstance = WebBrowserView(
        key: ValueKey(autoid), 
        url: newWindowWithUrl, 
        onTitleChanged: (title, logoUrl) {
          setState(() {
            webTabs[currentIndex].title = title;
            webTabs[currentIndex].logo = logoUrl;
          }); 
        }, onPageCompleted: (url, canBack, canForward) {
          setState(() {
            webTabs[currentIndex].url = url; 
          });
        }, onOpenWindow: (urlForNewWindow) {
          createNewTab(newWindowWithUrl: urlForNewWindow);
        },
      );  
      setState(() { 
        selectedTabIndex = currentIndex;
      });
      return;
    }   
    webTabs.last.pageInstance = HomeContentDefaultView( 
      key: ValueKey(autoid),
      onSearchText: (searchText) { 
        int currentIndex = selectedTabIndex;  
        String searchKeyword = searchText.trim();   
        if (searchKeyword.isEmpty) {
          return;
        }   
        if (!UrlUtil.isLikelyUrl(searchKeyword)) {
          // todo , only chat with ToutCas
          return;
        }
        String nUrl = UrlUtil.getURLWithHttps(searchKeyword); 
        setState(() {
          webTabs[currentIndex].url = nUrl; 
          webTabs[currentIndex].title = "Untitled";
        }); 
        autoid++; 
        webTabs[currentIndex].pageInstance = WebBrowserView( 
          key: ValueKey(autoid),
          url: webTabs[currentIndex].url, 
          onTitleChanged: (title, logoUrl) {
            setState(() {
              webTabs[currentIndex].title = title;
              webTabs[currentIndex].logo = logoUrl;
            });
          }, onPageCompleted: (url, canBack, canForward) {
            setState(() {
              webTabs[currentIndex].url = url;
              webTabs[currentIndex].canBack = canBack;
              webTabs[currentIndex].canForward = canForward;
            });
          }, onOpenWindow: (urlForNewWindow) {
            createNewTab(newWindowWithUrl: urlForNewWindow);
          }
        );  
      }
    );  
  }

  void refreshWithKeyword(String keyword) { 
    String searchKeyword = keyword.trim(); 
    if (searchKeyword.isEmpty) {
      return;
    }  
    final webTab = webTabs[selectedTabIndex];
    String newUrl = UrlUtil.getURLWithHttps(searchKeyword);
    String oldUrl = webTab.url; 
    setState(() {
      webTabs[selectedTabIndex].url = newUrl;
      webTabs[selectedTabIndex].title = "Untitled";
    }); 
    if (oldUrl != newUrl && webTab.pageInstance is WebBrowserView) {  
      WebBrowserView pageInstance = webTab.pageInstance as WebBrowserView;
      pageInstance.refreshWithUrl(newUrl);   
    } else { 
      int currentIndex = selectedTabIndex; 
      autoid++;
      webTabs[selectedTabIndex].pageInstance = WebBrowserView(
        key: ValueKey(autoid), 
        url: webTab.url, 
        onTitleChanged: (title, logoUrl) {
          setState(() {
            webTabs[currentIndex].title = title;
            webTabs[currentIndex].logo = logoUrl;
          }); 
        }, onPageCompleted: (url, canBack, canForward) {
          setState(() {
            webTabs[currentIndex].url = url;
            webTabs[currentIndex].canBack = canBack;
            webTabs[currentIndex].canForward = canForward;
          });
        }, onOpenWindow: (urlForNewWindow) {
          createNewTab(newWindowWithUrl: urlForNewWindow);
        },
      ); 
    }
  }

  void handlePageStatus(String action) async {
    if (webTabs[selectedTabIndex].pageInstance is WebBrowserView) {  
      WebBrowserView pageInstance = webTabs[selectedTabIndex].pageInstance as WebBrowserView;
      await pageInstance.handlePageStatus(action); 
      Future.delayed(Duration(milliseconds: 500), () async {
        String cUrl = await pageInstance.getCurrentUrl();
        if (cUrl.isNotEmpty) {
          webTabs[selectedTabIndex].url = cUrl;
        }
        webTabs[selectedTabIndex].canBack = await pageInstance.canBack();
        webTabs[selectedTabIndex].canForward = await pageInstance. canForward();
        setState(() {});
      });
    }
  }

  String getUpdatedLabel(String t) {
    if (t == "New Chat") {
      return AppLocalizations.of(context)?.newChat ?? "New Chat";
    } else if (t == "Settings") {
      return AppLocalizations.of(context)?.settings ?? "Settings";
    }
    return t; 
  }

}


class NavSideItem {
  final String type;
  final IconData icon;
  String label; 
  NavSideItem({required this.type, required this.icon, required this.label});
}

class LeftMenuConfig {
  double maxWidth = 160;
  double minWidth = 40;

  int? hoveredIndex;
  
  final List<NavSideItem> items = [
    NavSideItem(type: "new_chat", icon: Icons.edit_rounded, label: 'New Chat'),
    NavSideItem(type: "settings", icon: Icons.settings_rounded, label: 'Settings'), 
  ];

}
 
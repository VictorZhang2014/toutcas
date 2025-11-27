import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: must_be_immutable
class WebBrowserView extends StatefulWidget { 
  final String url;
  final Function(String title, String logoUrl) onTitleChanged;
  final Function(String newUrl, bool canBack, bool canForward, String htmlcode) onPageCompleted;
  final Function(String urlForNewWindow) onOpenWindow;
  WebBrowserView({
    required Key key, 
    required this.url, 
    required this.onTitleChanged, 
    required this.onPageCompleted, 
    required this.onOpenWindow}) 
    : super(key: key); 

  InAppWebViewController? webViewController;

  @override
  State<WebBrowserView> createState() => _WebBrowserViewState();

  Future<void> refreshWithUrl(String newUrl) async {
    try {
      if (newUrl.isNotEmpty) {
        await webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(newUrl)),
        );
      } else {
        await webViewController?.reload();
      }
    } catch (e) {
      // optional: handle/log error
    } 
  }

  Future<void> handlePageStatus(String action) async {
    if (webViewController == null) {
      return;
    }
    if (action == "back") {
      if (await webViewController!.canGoBack()) await webViewController?.goBack();
    } else if (action == "forward") {
      if (await webViewController!.canGoForward()) await webViewController?.goForward();
    } else if (action == "refresh") {
      await webViewController?.reload();
    }
  }

  Future<String> getCurrentUrl() async { 
    WebUri? url = await webViewController?.getUrl();
    return url.toString(); 
  }

  Future<bool> canBack() async { 
    return await webViewController?.canGoBack() ?? false; 
  }

  Future<bool> canForward() async { 
    return await webViewController?.canGoForward() ?? false; 
  }

}

class _WebBrowserViewState extends State<WebBrowserView> {

  double _progress = 10;   

  @override
  Widget build(BuildContext context) {  
    return Center(
      child: Column(
        children: [
          if (_progress < 1.0) 
            LinearProgressIndicator(
              value: _progress, 
              minHeight: 0.8, 
              backgroundColor: Colors.grey[200], 
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          Expanded(
            child: InAppWebView(   
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: _buildWebViewSettings(),
              onWebViewCreated: (controller) =>
                widget.webViewController = controller,
              onLoadStop: _onLoadStop,
              onProgressChanged: _onProgressChanged,
              onTitleChanged: _onTitleChanged, 
              onCreateWindow: _onCreateWindow,
            ),
          ),
        ],
      ),
    );
  }
 
  InAppWebViewSettings _buildWebViewSettings() => 
    InAppWebViewSettings(
      javaScriptEnabled: true,
      supportMultipleWindows: true,
      javaScriptCanOpenWindowsAutomatically: true,
      userAgent: _getUserAgent(),
  ); 

  Future<void> _onLoadStop(
    InAppWebViewController controller,
    WebUri? url,
  ) async {
    bool canBack = await widget.webViewController?.canGoBack() ?? false;
    bool canForward = await widget.webViewController?.canGoForward() ?? false;  
    String htmlcode = await controller.getHtml() ?? "";   
    widget.onPageCompleted(url.toString(), canBack, canForward, htmlcode);  
    if (htmlcode.contains('<embed name="plugin" src="${widget.url}" type="application/pdf">')) { 
      String? presetTitle = getPresetTitle("");  
      widget.onTitleChanged.call(presetTitle ?? "", ""); 
    }
  }

  void _onProgressChanged(InAppWebViewController controller, int progress) {
    setState(() {
      _progress = progress / 100;
    });
  }

  Future<void> _onTitleChanged(
    InAppWebViewController controller,
    String? title,
  ) async {  
    title = getPresetTitle(title); 
    final js = r'''
      (function(){
        const links = Array.from(document.querySelectorAll('link[rel~="icon"],link[rel="shortcut icon"],link[rel="apple-touch-icon"]'));
        const href = links.length ? links[0].href : '/favicon.ico';
        const url = new URL(href, location.href).href;
        return url;
      })();
      '''; 
    controller.evaluateJavascript(source: js).then((result) {
      widget.onTitleChanged.call(title ?? "", result ?? "");
    });
    widget.onTitleChanged.call(title ?? "", ""); 
  } 

  String _getUserAgent() {
    if (Platform.isMacOS) {
      return 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 ToutCas/1.0.1';
    } else if (Platform.isWindows) {
      return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 ToutCas/1.0.1';
    } else if (Platform.isLinux) {
      return 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 ToutCas/1.0.1';
    }
    // Provide a default or a generic desktop UA if needed
    return 'Mozilla/5.0 (Desktop; Flutter WebView) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'; 
  }

  Future<bool?> _onCreateWindow(
    InAppWebViewController controller,
    CreateWindowAction createWindowAction) async {  
    String newUrl = createWindowAction.request.url.toString(); 
    widget.onOpenWindow.call(newUrl); 
    return true;
  }

  String? getPresetTitle(String? title) {
    if (title == null || title.isEmpty) {
      if (widget.url.startsWith("https://arxiv.org")) { 
        title = "arXiv Paper ${widget.url.split("/").last}";
      } 
    }
    return title;
  }

}

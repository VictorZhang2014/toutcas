
class UrlUtil {

  static bool isLikelyUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.hasAuthority || uri.path.contains('.'));
  }

  static String getURLWithHttps(String url) {
    if (UrlUtil.isLikelyUrl(url)) {
      if (!url.startsWith("https://") && !url.startsWith("http://")) {
        return "https://$url";
      }
    }
    return url;
  }

  static String addHttpsToUrl(String url) { 
    if (!url.startsWith("https://") && !url.startsWith("http://")) {
      return "https://$url";
    } 
    return url;
  }

  static List<String> extractUrls(String text) {  
    final urlPattern = RegExp(r'\b(?:www\.|[a-zA-Z0-9-]+\.)[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(?:/[^\s]*)?\b'); 
    final matches = urlPattern.allMatches(text); 
    return matches.map((match) => match.group(0)!).toList();
  }

}
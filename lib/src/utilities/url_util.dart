
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

}
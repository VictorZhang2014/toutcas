
class IconTextModel {

  List<IconTextPair> models = [];

  IconTextModel() { 
    models = [
      IconTextPair(name: "Google", url: "https://www.google.com", logo: "https://www.google.com/favicon.ico"),
      IconTextPair(name: "Apple", url: "https://www.apple.com", logo: "https://www.apple.com/favicon.ico"),
      IconTextPair(name: "Microsoft", url: "https://www.microsoft.com", logo: "https://www.microsoft.com/favicon.ico"),
      IconTextPair(name: "Facebook", url: "https://www.facebook.com", logo: "https://www.facebook.com/favicon.ico"),
      IconTextPair(name: "Twitter", url: "https://www.twitter.com", logo: "https://www.twitter.com/favicon.ico"),
      IconTextPair(name: "X", url: "https://x.com", logo: "https://www.twitter.com/favicon.ico"),
      IconTextPair(name: "DeepSeek", url: "https://deepseek.com", logo: "https://deepseek.com/favicon.ico"),
      IconTextPair(name: "Grok", url: "https://grok.com", logo: "https://grok.com/favicon.ico"),
      IconTextPair(name: "Baidu", url: "https://www.baidu.com", logo: "https://www.baidu.com/favicon.ico"),
      IconTextPair(name: "OpenAI", url: "https://www.openai.com", logo: "https://www.openai.com/favicon.ico"),
      IconTextPair(name: "ChatGPT", url: "https://chatgpt.com", logo: "https://www.openai.com/favicon.ico"),
      IconTextPair(name: "Claude", url: "https://www.claude.ai", logo: "https://www.claude.ai/favicon.ico"),
      IconTextPair(name: "Yahoo", url: "https://www.yahoo.com", logo: "https://www.yahoo.com/favicon.ico"),
      IconTextPair(name: "Yandex", url: "https://www.yandex.com", logo: "https://www.yandex.com/favicon.ico"),
      IconTextPair(name: "Gmail", url: "https://mail.google.com", logo: "https://www.google.com/a/cpanel/nau.edu/images/favicon.ico"),
    ]; 
  }

  List<IconTextPair> getAllByKeyword(String keyword) {
    if (keyword.isEmpty) return [];
    return models
        .where((pair) => pair.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

}

class IconTextPair {
  final String name;
  final String url;
  final String logo;
  IconTextPair({required this.name, required this.url, required this.logo});
}

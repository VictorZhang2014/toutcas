

class LLMData {
  
  final List<Map<String, String>> messages = [];

  void addUserMessage(String content) {
    messages.add({
      'role': 'user',
      'content': content,
    });
  }

  void addAssistantMessage(String content) {
    messages.add({
      'role': 'assistant',
      'content': content,
    });
  }

  void addSystemMessage(String content) {
    messages.insert(0, {
      'role': 'system',
      'content': content,
    });
  }

  void clearHistory() {
    messages.clear();
  }

  List<Map<String, String>> getHistoryMessages() {
    return List.from(messages);
  }

}
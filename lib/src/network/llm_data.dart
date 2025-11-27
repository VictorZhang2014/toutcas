

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

class LLMResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> data;
  
  LLMResponse(this.success, this.message, this.data);

  static LLMResponse json(Map<String, String> dataMap) {
    return LLMResponse(
      dataMap["success"] as bool? ?? false,
      dataMap["message"] as String,
      dataMap["data"] as Map<String, String>? ?? {}
    ); 
  }

}
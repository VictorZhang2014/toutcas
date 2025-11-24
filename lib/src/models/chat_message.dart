

enum MessageType { text, image, document }

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final bool isSentByMe;
  final DateTime timestamp;
  final String? fileName;
  final String? filePath;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.isSentByMe,
    required this.timestamp,
    this.fileName,
    this.filePath,
  });
}

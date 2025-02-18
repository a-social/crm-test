class ChatChannel {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastUpdated;

  ChatChannel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastUpdated,
  });
}

class ChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
  });
}

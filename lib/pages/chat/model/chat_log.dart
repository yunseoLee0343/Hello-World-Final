class ChatLog {
  final String content;
  final String sender;

  ChatLog({
    required this.content,
    required this.sender,
  });

  factory ChatLog.fromJson(Map<String, dynamic> json) {
    return ChatLog(
      content: json['content'] as String,
      sender: json['sender'] as String,
    );
  }
}

class ChatRoom {
  final String roomId;
  final List<ChatLog> chatLogs;

  ChatRoom({
    required this.roomId,
    required this.chatLogs,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    final roomId = json['roomId'] as String;
    final chatLogsJson = json['chatLogs'] as List<dynamic>;
    final chatLogs = chatLogsJson
        .map((json) => ChatLog.fromJson(json as Map<String, dynamic>))
        .toList();

    return ChatRoom(
      roomId: roomId,
      chatLogs: chatLogs,
    );
  }
}

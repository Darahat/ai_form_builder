
class AiFormBuilderChatModel {
  final String? id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  AiFormBuilderChatModel({
    this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  factory AiFormBuilderChatModel.fromMap(Map<String, dynamic> map) {
    return AiFormBuilderChatModel(
      id: map['id'],
      message: map['message'],
      isUser: map['isUser'] == 1,
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  AiFormBuilderChatModel copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return AiFormBuilderChatModel(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

///making an extension instead of calling getAiFormBuilderChat() everytime to load all formBuilderChats
extension FormBuilderChatListUtils on List<AiFormBuilderChatModel> {
  /// Returns a formBuilderChat by its ID and applies the update.
  List<AiFormBuilderChatModel> updated(
    String tid,
    AiFormBuilderChatModel updatedChat,
  ) {
    return [
      for (final chat in this)
        if (chat.id == tid)
          /// When we find the Chat, create a new one with the updated title
          updatedChat
        else
          /// Otherwise, keep the existing formBuilderChat
          chat,
    ];
  }
}

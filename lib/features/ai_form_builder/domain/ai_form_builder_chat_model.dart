import 'package:hive/hive.dart';

part 'ai_form_builder_chat_model.g.dart';

@HiveType(typeId: 7)
/// Model for AI Form Builder chat messages
class AiFormBuilderChatModel {
  /// Unique identifier for the chat message
  @HiveField(0)
  final String? id;

  /// The content of the chat message
  @HiveField(1)
  final String message;

  /// Whether the message was sent by the user (true) or AI (false)
  @HiveField(2)
  final bool isUser;

  /// Timestamp when the message was sent
  @HiveField(3)
  final DateTime timestamp;

  /// Constructor for AiFormBuilderChatModel
  AiFormBuilderChatModel({
    this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  /// Creates a copy of an existing object with some updated fields
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
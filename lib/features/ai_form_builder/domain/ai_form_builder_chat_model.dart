import 'package:hive/hive.dart';

part 'ai_form_builder_chat_model.g.dart';

@HiveType(typeId: 7)
class AiFormBuilderChatModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String message;
  @HiveField(2)
  final bool isUser;
  @HiveField(3)
  final DateTime timestamp;

  AiFormBuilderChatModel({
    this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

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

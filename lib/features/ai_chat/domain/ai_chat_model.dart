import 'package:hive/hive.dart';

part 'ai_chat_model.g.dart';

@HiveType(typeId: 4)
class AiChatModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? chatTextBody;
  @HiveField(2)
  final String sentTime;
  @HiveField(3)
  final bool? isSeen;
  @HiveField(4)
  final bool? isReplied;
  @HiveField(5)
  final String? replyText;

  AiChatModel({
    this.id,
    this.chatTextBody,
    required this.sentTime,
    this.isSeen,
    this.isReplied,
    this.replyText,
  });

  factory AiChatModel.fromMap(Map<String, dynamic> map) {
    return AiChatModel(
      id: map['id'],
      chatTextBody: map['chatTextBody'],
      sentTime: map['sentTime'],
      isSeen: map['isSeen'] == 1,
      isReplied: map['isReplied'] == 1,
      replyText: map['replyText'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatTextBody': chatTextBody,
      'sentTime': sentTime,
      'isSeen': isSeen == true ? 1 : 0,
      'isReplied': isReplied == true ? 1 : 0,
      'replyText': replyText,
    };
  }

  AiChatModel copyWith({
    String? id,
    String? chatTextBody,
    String? sentTime,
    bool? isSeen,
    bool? isReplied,
    String? replyText,
  }) {
    return AiChatModel(
      id: id ?? this.id,
      chatTextBody: chatTextBody ?? this.chatTextBody,
      sentTime: sentTime ?? this.sentTime,
      isSeen: isSeen ?? this.isSeen,
      isReplied: isReplied ?? this.isReplied,
      replyText: replyText ?? this.replyText,
    );
  }
}

///making an extension instead of calling getAiChat() everytime to load all aiChats
extension AiChatListUtils on List<AiChatModel> {
  /// Returns a aiChat by its ID and applies the update.
  List<AiChatModel> updated(String tid, AiChatModel updatedChat) {
    return [
      for (final chat in this)
        if (chat.id == tid)

          /// When we find the aiChat, create a new one with the updated title
          updatedChat
        else

          /// Otherwise, keep the existing aiChat
          chat,
    ];
  }
}

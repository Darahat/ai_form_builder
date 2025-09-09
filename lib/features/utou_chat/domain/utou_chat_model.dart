import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'utou_chat_model.g.dart';

@HiveType(typeId: 5)
class UToUChatModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? chatTextBody;
  @HiveField(2)
  final DateTime sentTime;
  @HiveField(3)
  final bool? isDelivered;
  @HiveField(4)
  final bool? isRead;
  @HiveField(5)
  final String? senderId;
  @HiveField(6)
  final String? receiverId;

  UToUChatModel({
    required this.id,
    this.chatTextBody,
    required this.sentTime,
    this.isRead,
    this.isDelivered,
    this.senderId,
    this.receiverId,
  });

  factory UToUChatModel.fromMap(Map<String, dynamic> map) {
    return UToUChatModel(
      id: map['id'],
      chatTextBody: map['chatTextBody'],
      sentTime: DateTime.parse(map['sentTime']),
      isRead: map['isRead'] == 1,
      isDelivered: map['isDelivered'] == 1,
      senderId: map['senderId'],
      receiverId: map['receiverId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatTextBody': chatTextBody,
      'sentTime': sentTime.toIso8601String(),
      'isRead': isRead == true ? 1 : 0,
      'isDelivered': isDelivered == true ? 1 : 0,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  UToUChatModel copyWith({
    String? id,
    String? chatTextBody,
    DateTime? sentTime,
    bool? isRead,
    bool? isDelivered,
    String? senderId,
    String? receiverId,
  }) {
    return UToUChatModel(
      id: id ?? this.id,
      chatTextBody: chatTextBody ?? this.chatTextBody,
      sentTime: sentTime ?? this.sentTime,
      isRead: isRead ?? this.isRead,
      isDelivered: isDelivered ?? this.isDelivered,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
    );
  }

  factory UToUChatModel.fromJson(Map<String, dynamic> json) {
    return UToUChatModel(
      id: json['id'] as String,
      chatTextBody: json['chatTextBody'] as String?,
      sentTime: (json['sentTime'] as Timestamp).toDate(),
      isRead: json['isRead'] as bool?,
      isDelivered: json['isDelivered'] as bool?,
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatTextBody': chatTextBody,
      'sentTime': Timestamp.fromDate(sentTime),
      'isRead': isRead,
      'isDelivered': isDelivered,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }
}

///making an extension instead of calling getAiChat() everytime to load all aiChats
extension UToUChatListUtils on List<UToUChatModel> {
  /// Returns a aiChat by its ID and applies the update.
  List<UToUChatModel> updated(String id, UToUChatModel updatedChat) {
    return [
      for (final chat in this)
        if (chat.id == id)

          /// When we find the aiChat, create a new one with the updated title
          updatedChat
        else

          /// Otherwise, keep the existing aiChat
          chat,
    ];
  }
}

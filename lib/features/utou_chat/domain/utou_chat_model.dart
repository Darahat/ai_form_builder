import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'utou_chat_model.g.dart';

@HiveType(typeId: 5)
/// Model for peer-to-peer chat messages.
class UToUChatModel {
  /// first field for the hive/table is id
  @HiveField(0)
  final String id;

  /// Chat Body
  @HiveField(1)
  final String? chatTextBody;

  /// when the message sent
  @HiveField(2)
  final DateTime sentTime;

  /// is user/Ai isDelivered
  @HiveField(3)
  final bool? isDelivered;

  /// is user/ai is read/seen
  @HiveField(4)
  final bool? isRead;

  ///  user sender ID
  @HiveField(5)
  final String? senderId;

  /// User receiver ID
  @HiveField(6)
  final String? receiverId;

  /// its construct of UserModel class . its for call UserModel to other dart file.  this.name is not required
  UToUChatModel({
    required this.id,
    this.chatTextBody,
    required this.sentTime,
    this.isRead,
    this.isDelivered,
    this.senderId,
    this.receiverId,
  });

  ///creating a copy of an existing object with some updated fields and the actual object remain unchanged
  ///its used when need to update any field .
  ///used riverpod to state management.
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

  /// Map firestore returned data and set them to modal variables
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

  /// make modal object to json to use in firestore
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

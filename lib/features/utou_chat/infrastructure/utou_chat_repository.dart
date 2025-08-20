import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/utou_chat/domain/utou_chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';

/// A repository class for managing uToUChat-related operation using hive
class UToUChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// The hive box containing [UToUChatModel] instances.

  Box<UToUChatModel> get _box => HiveService.uTouChatBoxInit;

  /// get Chat Room ID
  String getChatRoomId(String? userId1, String userId2) {
    if (userId1.hashCode <= userId2.hashCode) {
      return '$userId1-$userId2';
    } else {
      return '$userId2-$userId1';
    }
  }

  /// SendMessage function to send message to specific Chat room
  Future<void> sendMessage(UToUChatModel chat) async {
    final chatRoomId = getChatRoomId(chat.senderId!, chat.receiverId!);
    final messageRef = _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(chat.id);
    try {
      await messageRef.set(chat.toJson());
      await _box.put(chat.id, chat);
    } catch (e, s) {
      AppLogger.debug(
        'I am from uTou_chat_repository.dart. Error: $e and state is $s',
      );
    }
  }

  /// Get Online messages from firestore
  Stream<List<UToUChatModel>> getMessages(
    String? currentUserId,
    String otherUserId,
  ) {
    final chatRoomId = getChatRoomId(currentUserId ?? '', otherUserId);
    try {
      return _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('sentTime', descending: false)
          .snapshots()
          .map((snapshot) {
            final messages =
                snapshot.docs.map((doc) {
                  final message = UToUChatModel.fromJson(doc.data());
                  _box.put(message.id, message);
                  return message;
                }).toList();
            return messages;
          });
    } catch (e, s) {
      AppLogger.debug(
        'I am from uTou_chat_repository.dart. getMessages Error: $e and state is $s',
      );
      // Throw to satisfy the non-nullable return type
      throw Exception('Failed to get messages: $e');
    }
  }

  /// get offline uToUChat from the local Hive storages.
  ///
  /// Returns a [List] of [UToUChatModel] instances
  Future<List<UToUChatModel>> getOfflineUtoUMessages(
    String currentUserId,
    String otherUserId,
  ) async {
    final allMessages = _box.values.toList();
    return allMessages
        .where(
          (message) =>
              (message.senderId == currentUserId &&
                  message.receiverId == otherUserId) ||
              (message.senderId == otherUserId &&
                  message.receiverId == current),
        )
        .toList();
  }

  /// Adds a new uToUChat with the given [text] as the title.
  Future<UToUChatModel?> addOfflineUtoUChat(UToUChatModel message) async {
    await _box.put(message.id, message);
    return message;
  }

  /// Toggles the completion status of a isSeen identified by [id]
  ///
  /// if the uToUChat exists, it will be updated with the opposite 'isCompleted' value.
  Future<void> toggleIsReadChat(
    String id,
    String receiverId,
    String senderId,
  ) async {
    final uToUChat = _box.get(id);
    if (uToUChat != null) {
      final updated = uToUChat.copyWith(isRead: !(uToUChat.isRead ?? false));
      await _box.put(id, updated);
      await updateMessageReadStatus(id, receiverId, senderId);
    }
  }

  /// Update message read status in Firestore
  Future<void> updateMessageReadStatus(
    String messageId,
    String receiverId,
    String senderId,
  ) async {
    final chatRoomId = getChatRoomId(receiverId, senderId);
    final messageRef = _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId);
    await messageRef.update({'isRead': true});
  }

  /// Toggle/Update value of isReplied
  Future<void> toggleIsDeliveredChat(String id) async {
    final uToUChat = _box.get(id);
    if (uToUChat != null) {
      final updated = uToUChat.copyWith(
        isDelivered: !(uToUChat.isDelivered ?? false),
      );
      await _box.put(id, updated);
    }
  }

  /// Removes the chat identified by [tid] from local storage
  Future<void> removeChat(String id) async {
    await _box.delete(id);
  }

  /// Updates the title of the uToUChat identified by [id] with [chatTextBody]
  Future<void> editUserChat(String id, String newChatTextBody) async {
    final uToUChat = _box.get(id);
    if (uToUChat != null) {
      final updated = uToUChat.copyWith(chatTextBody: newChatTextBody);
      await _box.put(id, updated);
    }
  }

  /// Update an existing chat in the database
  Future<void> updateUToUChat(String id, UToUChatModel chat) async {
    await _box.put(id, chat);
  }
}

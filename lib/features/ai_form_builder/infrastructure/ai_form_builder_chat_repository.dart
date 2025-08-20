import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:hive/hive.dart';

import '../domain/ai_chat_model.dart';

/// A repository class for managing aiChat-related operation using hive
class AiChatRepository {
  /// The hive box containing [AiChatModel] instances.

  Box<AiChatModel> get _box => HiveService.formBuilderChatBox;

  /// Retrives all aiChat from the local Hive storages.
  ///
  /// Returns a [List] of [AiChatModel] instances
  Future<List<AiChatModel>> getAiChat() async {
    return _box.values.toList();
  }

  /// Adds a new aiChat with the given [text] as the title.
  Future<AiChatModel?> addAiChat(String usersText) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final aiChat = AiChatModel(
      id: key,
      chatTextBody: usersText,
      sentTime: DateTime.now().toIso8601String(),
      isSeen: false,
      isReplied: false,
      replyText: '',
    );
    await _box.put(key, aiChat);
    return aiChat;
  }

  /// Toggles the completion status of a isSeen identified by [id]
  ///
  /// if the aiChat exists, it will be updated with the opposite 'isCompleted' value.
  Future<void> toggleIsSeenChat(String id) async {
    final aiChat = _box.get(id);
    if (aiChat != null) {
      final updated = aiChat.copyWith(isSeen: !(aiChat.isSeen ?? false));
      await _box.put(id, updated);
    }
  }

  /// Toggle/Update value of isReplied
  Future<void> toggleIsRepliedChat(String id) async {
    final aiChat = _box.get(id);
    if (aiChat != null) {
      final updated = aiChat.copyWith(isReplied: !(aiChat.isReplied ?? false));
      await _box.put(id, updated);
    }
  }

  /// Removes the chat identified by [tid] from local storage
  Future<void> removeChat(String id) async {
    await _box.delete(id);
  }

  /// Updates the title of the aiChat identified by [id] with [chatTextBody]
  Future<void> editUserChat(String id, String newChatTextBody) async {
    final aiChat = _box.get(id);
    if (aiChat != null) {
      final updated = aiChat.copyWith(chatTextBody: newChatTextBody);
      await _box.put(id, updated);
    }
  }

  /// Update an existing chat in the database
  Future<void> updateAiChat(String id, AiChatModel chat) async {
    await _box.put(id, chat);
  }
}

import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:hive/hive.dart';

import '../domain/ai_form_builder_chat_model.dart';

/// A repository class for managing aiFormBuilderChat-related operation using hive
class AiFormBuilderChatRepository {
  /// The hive box containing [AiFormBuilderChatModel] instances.

  Box<AiFormBuilderChatModel> get _box => HiveService.formBuilderChatBox;

  /// Retrives all aiFormBuilderChat from the local Hive storages.
  ///
  /// Returns a [List] of [AiFormBuilderChatModel] instances
  Future<List<AiFormBuilderChatModel>> getAiFormBuilderChat() async {
    return _box.values.toList();
  }

  /// Adds a new aiFormBuilderChat with the given [text] as the title.
  Future<AiFormBuilderChatModel?> addAiFormBuilderChat(String usersText) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final aiFormBuilderChat = AiFormBuilderChatModel(
      id: key,
      chatTextBody: usersText,
      sentTime: DateTime.now().toIso8601String(),
      isSeen: false,
      isReplied: false,
      replyText: '',
    );
    await _box.put(key, aiFormBuilderChat);
    return aiFormBuilderChat;
  }

  /// Toggles the completion status of a isSeen identified by [id]
  ///
  /// if the aiFormBuilderChat exists, it will be updated with the opposite 'isCompleted' value.
  Future<void> toggleIsSeenChat(String id) async {
    final aiFormBuilderChat = _box.get(id);
    if (aiFormBuilderChat != null) {
      final updated = aiFormBuilderChat.copyWith(
        isSeen: !(aiFormBuilderChat.isSeen ?? false),
      );
      await _box.put(id, updated);
    }
  }

  /// Toggle/Update value of isReplied
  Future<void> toggleIsRepliedChat(String id) async {
    final aiFormBuilderChat = _box.get(id);
    if (aiFormBuilderChat != null) {
      final updated = aiFormBuilderChat.copyWith(
        isReplied: !(aiFormBuilderChat.isReplied ?? false),
      );
      await _box.put(id, updated);
    }
  }

  /// Removes the chat identified by [tid] from local storage
  Future<void> removeChat(String id) async {
    await _box.delete(id);
  }

  /// Updates the title of the aiFormBuilderChat identified by [id] with [chatTextBody]
  Future<void> editUserChat(String id, String newChatTextBody) async {
    final aiFormBuilderChat = _box.get(id);
    if (aiFormBuilderChat != null) {
      final updated = aiFormBuilderChat.copyWith(chatTextBody: newChatTextBody);
      await _box.put(id, updated);
    }
  }

  /// Update an existing chat in the database
  Future<void> updateAiFormBuilderChat(
    String id,
    AiFormBuilderChatModel chat,
  ) async {
    await _box.put(id, chat);
  }
}

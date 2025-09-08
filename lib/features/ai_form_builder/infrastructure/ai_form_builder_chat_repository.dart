import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:hive/hive.dart';

import '../domain/ai_form_builder_chat_model.dart';

class AiFormBuilderChatRepository {
  /// The hive box containing [AiFormBuilderChatModel] instances.
  final HiveService _hiveService;
  Box<AiFormBuilderChatModel> get _box => _hiveService.formBuilderChatBox;

  ///AiFormBuilderChatRepository constructor
  AiFormBuilderChatRepository(this._hiveService);

  /// get all aiFormBuilderChat from the local Hive storages.
  ///
  /// Returns a [List] of [AiFormBuilderChatModel] instances

  Future<List<AiFormBuilderChatModel>> getAiFormBuilderChat() async {
    return _box.values.toList();
  }

  Future<AiFormBuilderChatModel?> addAiFormBuilderChat(String text) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final aiFormBuilderChat = AiFormBuilderChatModel(
      id: key,
      message: text,
      timestamp: DateTime.now(),
      isUser: false,
    );
    await _box.put(key, aiFormBuilderChat);
    return aiFormBuilderChat;
  }

  Future<void> removeChat(String id) async {
    await _box.delete(id);
  }

  Future<void> editUserChat(String id, String newChatTextBody) async {
    final currentChat = _box.get(id);
    if (currentChat != null) {
      final updated = currentChat.copyWith(message: newChatTextBody);
      await _box.put(id, updated);
    }
  }

  Future<void> updateAiFormBuilderChat(
    String id,
    AiFormBuilderChatModel chat,
  ) async {
    await _box.put(id, chat);
  }
}

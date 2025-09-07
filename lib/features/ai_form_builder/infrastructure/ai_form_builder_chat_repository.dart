import 'package:ai_form_builder/core/services/database_service.dart';

import '../domain/ai_form_builder_chat_model.dart';

class AiFormBuilderChatRepository {
  final DatabaseService _databaseService;

  AiFormBuilderChatRepository(this._databaseService);

  Future<List<AiFormBuilderChatModel>> getAiFormBuilderChat() async {
    final db = await _databaseService.database;
    final maps = await db.query('ai_form_builder_chats');
    return maps.map((map) => AiFormBuilderChatModel.fromMap(map)).toList();
  }

  Future<AiFormBuilderChatModel?> addAiFormBuilderChat(String text) async {
    final db = await _databaseService.database;
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final aiFormBuilderChat = AiFormBuilderChatModel(
      id: key,
      message: text,
      timestamp: DateTime.now(),
      isUser: false,
    );
    await db.insert('ai_form_builder_chats', aiFormBuilderChat.toMap());
    return aiFormBuilderChat;
  }

  Future<void> removeChat(String id) async {
    final db = await _databaseService.database;
    await db.delete('ai_form_builder_chats', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> editUserChat(String id, String newChatTextBody) async {
    final db = await _databaseService.database;
    final maps = await db.query('ai_form_builder_chats', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      final currentChat = AiFormBuilderChatModel.fromMap(maps.first);
      final updated = currentChat.copyWith(message: newChatTextBody);
      await db.update('ai_form_builder_chats', updated.toMap(), where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<void> updateAiFormBuilderChat(
    String id,
    AiFormBuilderChatModel chat,
  ) async {
    final db = await _databaseService.database;
    await db.update('ai_form_builder_chats', chat.toMap(), where: 'id = ?', whereArgs: [id]);
  }
}

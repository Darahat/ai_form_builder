import 'package:ai_form_builder/core/services/database_service.dart';
import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ai_chat_model.dart';

class AiChatRepository {
  final DatabaseService _databaseService;
  final AppLogger _appLogger;
  final Ref _ref;

  AiChatRepository(this._ref, this._databaseService, this._appLogger);

  Future<List<AiChatModel>> getAiChat() async {
    final db = await _databaseService.database;
    final maps = await db.query('ai_chats');
    return maps.map((map) => AiChatModel.fromMap(map)).toList();
  }

  Future<AiChatModel?> addAiChat(String usersText) async {
    final db = await _databaseService.database;
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final aiChat = AiChatModel(
      id: key,
      chatTextBody: usersText,
      sentTime: DateTime.now().toIso8601String(),
      isSeen: false,
      isReplied: false,
      replyText: '',
    );
    await db.insert('ai_chats', aiChat.toMap());
    return aiChat;
  }

  Future<void> toggleIsSeenChat(String id) async {
    final db = await _databaseService.database;
    final maps = await db.query('ai_chats', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      final currentChat = AiChatModel.fromMap(maps.first);
      final updated = currentChat.copyWith(isSeen: !(currentChat.isSeen ?? false));
      await db.update('ai_chats', updated.toMap(), where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<void> toggleIsRepliedChat(String id) async {
    final db = await _databaseService.database;
    final maps = await db.query('ai_chats', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      final currentChat = AiChatModel.fromMap(maps.first);
      final updated = currentChat.copyWith(isReplied: !(currentChat.isReplied ?? false));
      await db.update('ai_chats', updated.toMap(), where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<void> removeChat(String id) async {
    final db = await _databaseService.database;
    await db.delete('ai_chats', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> editUserChat(String id, String newChatTextBody) async {
    final db = await _databaseService.database;
    final maps = await db.query('ai_chats', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      final currentChat = AiChatModel.fromMap(maps.first);
      final updated = currentChat.copyWith(chatTextBody: newChatTextBody);
      await db.update('ai_chats', updated.toMap(), where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<void> updateAiChat(String id, AiChatModel chat) async {
    final db = await _databaseService.database;
    await db.update('ai_chats', chat.toMap(), where: 'id = ?', whereArgs: [id]);
  }
}

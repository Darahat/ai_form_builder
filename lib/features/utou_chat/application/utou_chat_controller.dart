import 'package:ai_form_builder/core/services/sound_service.dart';
import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/utou_chat/domain/utou_chat_model.dart';
import 'package:ai_form_builder/features/utou_chat/infrastructure/utou_chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Used to indicate loading status in the UI
final uToUChatLoadingProvider = StateProvider<bool>((ref) => false);

/// Main UToU Chat Controller connected to Hive-backed UToUChatRepository
class UToUChatController
    extends StateNotifier<AsyncValue<List<UToUChatModel>>> {
  final UToUChatRepository _repo;
  final AppLogger _appLogger;
  final SoundService _soundService;
  final Box<UToUChatModel> _box;

  /// UToUChatController Constructor to call it from outside
  UToUChatController(this._repo, this._appLogger, this._box)
      : _soundService = SoundService(_appLogger),
        super(const AsyncValue.loading());

  /// Load all uToUChats from repository and update the state
  Future<void> loadUToUOfflineChat(
    String currentUserId,
    String otherUserId,
  ) async {
    state = const AsyncValue.loading();
    try {
      final uToUChats = await _repo.getOfflineUtoUMessages(
        currentUserId,
        otherUserId,
      );

      /// Filter for incomplete uToUChats and set the data state
      state = AsyncValue.data(uToUChats);
    } catch (e, s) {
      /// If loading fails, set the error state
      state = AsyncValue.error(e, s);
    }
  }

  /// Add a new uToUChat and reload list
  Future<void> addUToUChat(
    String usersText,
    String systemPrompt,
    String userPromptPrefix,
    String systemQuickReplyPrompt,
    String errorMistralRequest,
    String senderId,
    String receiverId,
  ) async {
    /// Get The current list of uToUChats from the state's value
    final currentUToUChats = state.value ?? [];
    final message = UToUChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatTextBody: usersText,
      sentTime: DateTime.now(),
      senderId: senderId,
      receiverId: receiverId,
      isRead: false,
      isDelivered: true, // Message is sent to Firestore
    );
    final usersMessage = await _repo.addOfflineUtoUChat(message);
    await _repo.sendMessage(message);
    if (usersMessage == null) return;
    state = AsyncValue.data([...currentUToUChats, usersMessage]);
  }

  /// Toggle a uToUChat and reload list
  Future<void> toggleIsReadChat(
    String id,
    String receiverId,
    String senderId,
  ) async {
    final currentChats = state.value ?? [];
    if (currentChats.isEmpty) return;
    await _repo.toggleIsReadChat(id, receiverId, senderId);

    final updatedList = currentChats.map((chat) {
      if (chat.id == id) {
        return chat.copyWith(isRead: !(chat.isRead ?? false));
      }
      return chat;
    }).toList();

    /// Update the state with the new list
    state = AsyncValue.data(updatedList);
  }

  /// Update chat status value of is it replied
  Future<void> toggleIsRepliedChat(String id) async {
    final currentChats = state.value ?? [];
    if (currentChats.isEmpty) return;

    await _repo.toggleIsDeliveredChat(id);
    final updatedList = currentChats.map((chat) {
      if (chat.id == id) {
        return chat.copyWith(isDelivered: !(chat.isDelivered ?? false));
      }
      return chat;
    }).toList();
    state = AsyncValue.data(updatedList);
  }

  /// Remove a uToUChat and reload list
  Future<void> removeUToUChat(String id) async {
    final currentUToUChats = state.value ?? [];

    await _repo.removeChat(id);
    state = AsyncValue.data(
      currentUToUChats.where((chat) => chat.id != id).toList(),
    );
  }

  /// Edit a uToUChat and reload list
  Future<void> editUToUChat(String id, String newText) async {
    final currentUToUChats = state.value ?? [];
    if (currentUToUChats.isEmpty) return;
    await _repo.editUserChat(id, newText);

    final updatedList = currentUToUChats.map((chat) {
      if (chat.id == id) {
        return chat.copyWith(chatTextBody: newText);
      }
      return chat;
    }).toList();

    /// Update the state with the new list
    state = AsyncValue.data(updatedList);
  }

  /// if New message detect it will be called
  void onNewMessageReceived(message) {
    _soundService.playNotificationSound();
  }
}

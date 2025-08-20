import 'package:ai_chat/core/services/sound_service.dart';
import 'package:ai_chat/features/utou_chat/domain/utou_chat_model.dart';
import 'package:ai_chat/features/utou_chat/infrastructure/utou_chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Used to indicate loading status in the UI
final uToUChatLoadingProvider = StateProvider<bool>((ref) => false);

/// Main UToU Chat Controller connected to Hive-backed UToUChatRepository
class UToUChatController
    extends StateNotifier<AsyncValue<List<UToUChatModel>>> {
  final UToUChatRepository _repo;
  final SoundService _soundService = SoundService();

  /// ref is a riverpod object which used by providers to interact with other providers and life cycle
  /// of the application
  /// example ref.read, ref.write etc
  final Ref ref;

  /// UToUChatController Constructor to call it from outside
  UToUChatController(this._repo, this.ref) : super(const AsyncValue.loading());

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

    // final chatToUpdate = currentChats.firstWhere((t) => t.id == id);

    /// changing uToUChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    ///
    final updatedList =
        currentChats.map((chat) {
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
    final chatToUpdate = currentChats.firstWhere((chat) => chat.id == id);
    final updatedList = currentChats.updated(
      id,
      chatToUpdate.copyWith(isDelivered: !(chatToUpdate.isDelivered ?? false)),
    );
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
    final uToUChatToUpdate = currentUToUChats.firstWhere((t) => t.id == id);

    /// changing aiChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    final updatedList = currentUToUChats.updated(
      id,
      uToUChatToUpdate.copyWith(chatTextBody: newText),
    );

    /// Update the state with the new list
    state = AsyncValue.data(updatedList);
  }

  /// if New message detect it will be called
  void onNewMessageReceived(message) {
    _soundService.playNotificationSound();
  }
}

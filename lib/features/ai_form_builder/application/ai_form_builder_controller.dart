import 'package:ai_form_builder/core/errors/exceptions.dart';
import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/core/utils/form_generator.dart';
import 'package:ai_form_builder/features/ai_form_builder/infrastructure/ai_generated_form_repository.dart';
// import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/ai_form_builder/provider/ai_form_builder_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ai_form_builder_chat_model.dart';
import '../infrastructure/ai_form_builder_chat_repository.dart';
// At the top of the file, after imports
// Placeholder for local development

/// Used to indicate loading status in the UI
final formBuilderChatLoadingProvider = StateProvider<bool>((ref) => false);

/// Main Ai Chat Controller connected to Hive-backed AiFormBuilderChatRepository
class AiFormBuilderChatController
    extends StateNotifier<AsyncValue<List<AiFormBuilderChatModel>>> {
  final AiFormBuilderChatRepository _repo;

  /// instance for hiveService
  HiveService hiveService;
  AiGeneratedFormRepository aiGeneratedFormRepository;

  /// ref is a riverpod object which used by providers to interact with other providers and life cycle
  /// of the application
  /// example ref.read, ref.write etc
  final Ref ref;

  /// AiFormBuilderChatController Constructor to call it from outside
  AiFormBuilderChatController(
      this._repo, this.ref, this.aiGeneratedFormRepository, this.hiveService)
      : super(const AsyncValue.loading()) {
    loadAiFormBuilderChat();
  }

  /// Load all aiFormBuilderChats from repository and update the state
  Future<void> loadAiFormBuilderChat() async {
    if (!mounted) return;
    state = const AsyncValue.loading();
    try {
      final aiFormBuilderChats = await _repo.getAiFormBuilderChat();
      if (!mounted) return;

      /// Filter for incomplete aiFormBuilderChats and set the data state
      state = AsyncValue.data(aiFormBuilderChats);
    } catch (e, s) {
      if (!mounted) return;

      /// If loading fails, set the error state
      state = AsyncValue.error(e, s);
    }
  }

  /// Add a new aiFormBuilderChat and reload list
  Future<void> addAiFormBuilderChat(
    String usersText,
    String systemPrompt,
  ) async {
    // final logger = ref.watch(appLoggerProvider);

    /// Get The current list of aiFormBuilderChats from the state's value
    final currentAiFormBuilderChats = state.value ?? [];

    // Create the user's message
    final usersMessage = AiFormBuilderChatModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Unique ID for user message
      message: usersText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Save user's message to repository
    await _repo.addAiFormBuilderChat(usersMessage);

    if (!mounted) return;
    state = AsyncValue.data([...currentAiFormBuilderChats, usersMessage]);

    try {
      /// Get AI Reply
      final mistralService = ref.read(mistralServiceProvider);

      // 1. Get the chat history from the state
      final chatHistory = state.value
              ?.map((chat) {
                return [
                  {"role": "user", "content": chat.message}, // Use chat.message
                  {
                    "role": "assistant",
                    "content": chat.message,
                  }, // Use chat.message
                ];
              })
              .expand((element) => element)
              .toList() ??
          [];

      final aiReplyText = await mistralService.generateFormBuilderQuestions(
        usersText,
        chatHistory,
        systemPrompt,
      );

      final form = await FormGenerator.parseAndSaveForm(
        ref,
        hiveService,
        aiGeneratedFormRepository,
        aiReplyText,
      );

      /// Create Firebase Dynamic Link if form was saved
      String? formUrl = '';
      if (form != null) {
        formUrl = "https://darahat.dev/form/${form.id}";
      }

      final aiMessageContent = form != null
          ? "Your form has been created! You can share it using this link: $formUrl"
          : aiReplyText;

      // Create a new AiFormBuilderChatModel for the AI's reply
      final aiMessage = AiFormBuilderChatModel(
        id: form?.id ??
            DateTime.now()
                .millisecondsSinceEpoch
                .toString(), // Use form ID or new unique ID
        message: aiMessageContent,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Save AI's message to repository
      await _repo.addAiFormBuilderChat(aiMessage);

      // Add the AI's message to the state
      if (!mounted) return;
      state = AsyncValue.data(
        [...state.value!, aiMessage], // Add the new AI message
      );
    } catch (e, s) {
      throw ServerException(
        '🚀 ~Save on hive of mistral reply from (ai_form_builder_controller.dart) $e and this is $s',
      );
    }
  }

  /// Remove a aiFormBuilderChat and reload list
  Future<void> removeAiFormBuilderChat(String id) async {
    final currentAiFormBuilderChats = state.value ?? [];

    await _repo.removeChat(id);
    if (!mounted) return;
    state = AsyncValue.data(
      currentAiFormBuilderChats.where((chat) => chat.id != id).toList(),
    );
  }

  /// Edit a aiFormBuilderChat and reload list
  Future<void> editAiFormBuilderChat(String id, String newText) async {
    final currentAiFormBuilderChats = state.value ?? [];
    if (currentAiFormBuilderChats.isEmpty) return;
    await _repo.editUserChat(id, newText);
    final aiFormBuilderChatToUpdate = currentAiFormBuilderChats.firstWhere(
      (t) => t.id == id,
    );

    /// changing aiFormBuilderChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    final updatedList = currentAiFormBuilderChats.updated(
      id,
      aiFormBuilderChatToUpdate.copyWith(message: newText), // Use message
    );

    /// Update the state with the new list
    if (!mounted) return;
    state = AsyncValue.data(updatedList);
  }
}

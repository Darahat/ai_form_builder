import 'package:ai_form_builder/core/services/hive_service.dart';
import 'package:ai_form_builder/core/services/mistral_service.dart';
import 'package:ai_form_builder/core/services/voice_to_text_service.dart';
import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/ai_form_builder/domain/form_field_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/ai_form_builder_controller.dart';
import '../domain/ai_form_builder_chat_model.dart';
import '../infrastructure/ai_form_builder_chat_repository.dart';
import '../infrastructure/ai_generated_form_repository.dart';

/// Provider for the chat repository
final aiFormBuilderChatRepositoryProvider =
    Provider<AiFormBuilderChatRepository>((ref) {
      final hiveService = ref.watch(hiveServiceProvider);
      return AiFormBuilderChatRepository(hiveService);
    });

/// Provider for the generated form repository
final aiGeneratedFormRepositoryProvider = Provider<AiGeneratedFormRepository>((
  ref,
) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AiGeneratedFormRepository(hiveService);
});

/// function for call getAiGeneratedFormById so that passing form id its being possible to get the form information
final aiGeneratedFormModelProvider =
    FutureProvider.family<AiGeneratedFormModel?, String>((ref, formId) async {
      final repository = ref.watch(aiGeneratedFormRepositoryProvider);
      return repository.getAiGeneratedFormById(formId);
    });

/// Voice input for adding aiFormBuilderChat
final voiceToTextProvider = Provider<VoiceToTextService>((ref) {
  final logger = ref.watch(appLoggerProvider);

  return VoiceToTextService(ref, logger);
});

/// Indicates whether voice is recording
final isListeningProvider = StateProvider<bool>((ref) => false);

/// to check The AISummary is expanded or not
final isExpandedSummaryProvider = StateProvider<bool>((ref) => false);

/// to check The Floating button is expanded or not
final isExpandedFabProvider = StateProvider<bool>((ref) => false);

/// Controller for aiFormBuilderChat logic and Hive access
final aiFormBuilderChatControllerProvider = StateNotifierProvider<
  AiFormBuilderChatController,
  AsyncValue<List<AiFormBuilderChatModel>>
>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);

  final repo = ref.watch(aiFormBuilderChatRepositoryProvider);
  return AiFormBuilderChatController(repo, ref, hiveService);
});

/// taking only those aiFormBuilderChats which are incomplete
// final incompleteTasksProvider = Provider<AsyncValue<List<AiFormBuilderChatModel>>>((ref) {
//   return ref.watch(aiFormBuilderChatControllerProvider);
// });

/// Mistral AI summary service
final mistralServiceProvider = Provider((ref) => MistralService());

/// Async summary from Mistral for aiFormBuilderChat list
/// Async summary from Mistral for incomplete aiFormBuilderChats
final aiSummaryProvider = FutureProvider<String>((ref) async {
  final aiFormBuilderChatAsync = ref.watch(aiFormBuilderChatControllerProvider);
  return aiFormBuilderChatAsync.when(
    data: (aiFormBuilderChats) {
      if (aiFormBuilderChats.isEmpty) {
        return "No Chat to answer";
      }
      final aiFeed = aiFormBuilderChats
          .map(
            (t) =>
                'just give answer very shortly.Like as human chat. the text is- ${t.message}',
          )
          .join('\n');
      final service = ref.read(mistralServiceProvider);
      return service.generateSummary(aiFeed);
    },
    error: (_, __) => "Could not generate answer due to an error",
    loading: () => "Generating answer....",
  );
});

/// Notifier for managing the state of the form values
class FormValuesNotifier extends StateNotifier<Map<String, dynamic>> {
  /// FormValuesNotifier Constructor
  FormValuesNotifier() : super({});

  /// Update value function
  void updateValue(String fieldId, dynamic value) {
    state = {...state, fieldId: value};
  }

  /// Function for Clear
  void clear() {
    state = {};
  }
}

/// Provider for the form values state
final formValuesProvider =
    StateNotifierProvider.autoDispose<FormValuesNotifier, Map<String, dynamic>>(
      (ref) {
        return FormValuesNotifier();
      },
    );

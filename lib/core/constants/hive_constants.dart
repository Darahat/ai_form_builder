/// HiveConstants is the carrier of hive boxes names
class HiveConstants {
  // Box for TextEntry model (typeId: 0)

  /// The file name for the local database.
  static const String databaseName = 'ai_form_builder.db';

  /// The version of the local database schema.
  static const int databaseVersion = 1;

  /// The Hive box used for general settings.
  static const String settingsBoxName = 'settings';

  /// table for user information saving and authentication
  static const String authBox = "user_auth_box";

  /// hive box for tasks
  static const String taskBox = "task_box";

  /// hive box for tasks
  static const String aiChatBox = "ai_form_builder_box";

  /// hive box for user to user chat
  static const String uTouChatBox = "uTou_chat_box";

  /// hive box for AI form Builder
  static const String formBuilderChatBox = "form_builder_chat_Box";

  /// hive box for what kind of question will exist in form
  static const String formFieldQuestionsBox = "generated_form_questions";

  /// hive box for generated forms title,ID, Description etc
  static const String aiGeneratedFormBox = "generated_form_info";
}

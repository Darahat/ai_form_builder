/// Configuration settings for the local database and Hive boxes.
class DatabaseConfig {
  /// The file name for the local database.
  static const String databaseName = 'ai_chat.db';

  /// The version of the local database schema.
  static const int databaseVersion = 1;

  /// The Hive box used for general settings.
  static const String hiveBoxName = 'settings';

  /// The Hive box used to store task data.
  static const String tasksBoxName = 'tasks';

  /// The Hive box used to store daily plan data.
  static const String plansBoxName = 'daily_plans';

  /// The Hive box used to store authentication data.
  static const String authBoxname = 'auth';
}

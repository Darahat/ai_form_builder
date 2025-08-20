/// A configuration class for app-wide static values such as name, version, and timeouts.
class AppConfig {
  /// The name of the application.
  static const String appName = 'FlutterStarterKit';

  /// The current version of the application.
  static const String appVersion = '1.0.0';

  /// Cache expiration time in seconds (1 hour).
  static const int cacheExpiration = 3600;

  /// Timeout duration for HTTP requests in seconds.
  static const int requestTimeout = 30;
}

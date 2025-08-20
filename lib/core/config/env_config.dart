/// A configuration class for managing environment-specific values.
///
/// Uses compile-time constants injected via `--dart-define`.
class EnvConfig {
  /// The base URL for API requests.
  ///
  /// Can be overridden using `--dart-define=API_BASE_URL=<url>`.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );
}

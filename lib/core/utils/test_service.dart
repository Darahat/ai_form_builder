import 'package:injectable/injectable.dart';

/// An abstract contract for the TestService.
///
/// This defines the interface for retrieving test messages,
/// which can be implemented using dependency injection for flexibility and testability.
abstract class TestService {
  /// Returns a test message indicating that the service is working.

  String getTestMessage();
}

/// A concrete implementation of [TestService].
///
/// This class is annotated with `@Injectable` to enable automatic dependency injection
/// using the `injectable` package. It provides a default test message.
@Injectable(as: TestService)
class TestServiceImpl implements TestService {
  @override
  String getTestMessage() => 'Dependency injection is working!';
}

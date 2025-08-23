import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/auth/application/auth_controller.dart';
import 'package:ai_form_builder/features/auth/application/auth_state.dart';
import 'package:ai_form_builder/features/auth/domain/user_model.dart';
import 'package:ai_form_builder/features/auth/infrastructure/auth_repository.dart';
import 'package:ai_form_builder/features/auth/provider/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

///1. Create a mock class for the dependency
class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthBox extends Mock implements Box<UserModel> {}

class FakeUserModel extends Fake implements UserModel {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  /// 2. Declare variables for the test
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;
  late UserModel testUser;
  late MockAuthBox mockAuthBox;
  late MockAppLogger mockAppLogger;

  testUser = UserModel(uid: '123', email: 'test@test.com', name: 'Test User');
  // 3. Set up the environment before each test
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthBox = MockAuthBox();
    mockAppLogger = MockAppLogger();
    container = ProviderContainer(
      overrides: [
        /// Override the real repository provider with our mock instance
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        authControllerProvider.overrideWith(
          (ref) => AuthController(
            mockAuthRepository,
            mockAuthBox,
            ref,
            mockAppLogger,
          ),
        ),
      ],
    );
    // Set up default behaviors for mocks
    when(
      () => mockAuthBox.put(any(), any()),
    ).thenAnswer((_) async => Future.value());
    when(() => mockAppLogger.debug(any())).thenAnswer((_) {});
    when(() => mockAppLogger.error(any(), any(), any())).thenAnswer((_) {});
  });

  /// 4. Tear down the environment after each test
  tearDown(() {
    container.dispose();
  });

  test('AuthController initial state is AuthInitial', () {
    /// Assert: Verify the state
    expect(container.read(authControllerProvider), const AuthInitial());
  });

  test('signIn successfully updates state to Authenticated', () async {
    /// Arrange: Set up the mock repository to return a user on success
    when(
      () => mockAuthRepository.signIn(any(), any()),
    ).thenAnswer((_) async => testUser);

    /// Act: Call the signIn method on the controller
    await container
        .read(authControllerProvider.notifier)
        .signIn('test@test.com', 'password');

    // Assert: verify the state is now authenticated with the correct user

    expect(container.read(authControllerProvider), Authenticated(testUser));
  });

  test('signIn failure updates state to AuthError', () async {
    /// Arrange: Set up the mock repository to throw an exception
    final exception = Exception('Sign in failed');
    when(() => mockAuthRepository.signIn(any(), any())).thenThrow(exception);

    /// Act: Call the signIn method
    await container
        .read(authControllerProvider.notifier)
        .signIn('test@test.com', 'wrongpassword');

    /// Assert: verify the state is AuthError
    final finalState = container.read(authControllerProvider);
    expect(finalState, AuthError(exception.toString(), AuthMethod.email));
  });

  group('Google Sign-In', () {
    test('successfully updates state to Authenticated', () async {
      /// Arrange
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => testUser);

      // Act
      await container.read(authControllerProvider.notifier).signInWithGoogle();

      /// assert
      expect(container.read(authControllerProvider), Authenticated(testUser));
      verify(() => mockAuthBox.put('user', testUser)).called(1);
    });
    test('failure updates state to AuthError', () async {
      // Arrange
      final exception = Exception('Google sign-in failed');
      when(() => mockAuthRepository.signInWithGoogle()).thenThrow(exception);

      /// Act
      await container.read(authControllerProvider.notifier).signInWithGoogle();

      /// Assert
      final expectedError = AuthError(exception.toString(), AuthMethod.google);
      expect(container.read(authControllerProvider), expectedError);
    });
  });

  group('Github Sign-In', () {
    test('successfully updates state to Authenticated', () async {
      /// Arrange
      when(
        () => mockAuthRepository.signInWithGithub(),
      ).thenAnswer((_) async => testUser);

      // Act
      await container.read(authControllerProvider.notifier).signInWithGithub();

      /// assert
      expect(container.read(authControllerProvider), Authenticated(testUser));
      verify(() => mockAuthBox.put('user', testUser)).called(1);
    });
    test('failure updates state to AuthError', () async {
      // Arrange
      final exception = Exception('Github sign-in failed');
      when(() => mockAuthRepository.signInWithGithub()).thenThrow(exception);

      /// Act
      await container.read(authControllerProvider.notifier).signInWithGithub();

      /// Assert
      final expectedError = AuthError(exception.toString(), AuthMethod.github);
      expect(container.read(authControllerProvider), expectedError);
    });
  });

  group('OTP Sign-In', () {
    const testPhoneNumber = '+8801765849345';
    const testVerificationId = 'test-verification-id';
    const testSmsCode = '673298';

    test('SendOTP successfully updates state to OTPSent', () async {
      /// Arrange
      /// We mock the repository's sendOTP method. when it's called.
      /// We immediately execute the codeSent callback to simulate
      /// firebase sending the code.
      when(
        () =>
            mockAuthRepository.sendOTP(any(), codeSent: any(named: 'codeSent')),
      ).thenAnswer((invocation) async {
        final codeSentCallback =
            invocation.namedArguments[#codeSent] as Function(String, int?);
        codeSentCallback(testVerificationId, null);
      });

      // Act
      await container
          .read(authControllerProvider.notifier)
          .sendOTP(testPhoneNumber);

      // Assert
      // The state should now be OTPSent because the callback was executed
      expect(container.read(authControllerProvider), const OTPSent());
    });
    test('verifyOTP successfully updates state to Authenticated', () async {
      /// Arrange: First we need to get the controller into the OTPSent state
      /// so that it has a verificationID
      when(
        () =>
            mockAuthRepository.sendOTP(any(), codeSent: any(named: 'codeSent')),
      ).thenAnswer((invocation) async {
        final codeSentCallback =
            invocation.namedArguments[#codeSent] as Function(String, int?);
        codeSentCallback(testVerificationId, null);
      });
      await container
          .read(authControllerProvider.notifier)
          .sendOTP(testPhoneNumber);

      /// Now, arrange for the verification step to succeed
      when(
        () => mockAuthRepository.verifyOTP(testVerificationId, testSmsCode),
      ).thenAnswer((_) async => testUser);

      /// Act
      await container
          .read(authControllerProvider.notifier)
          .verifyOTP(testSmsCode);

      /// Assert
      expect(container.read(authControllerProvider), Authenticated(testUser));
      verify(() => mockAuthBox.put('user', testUser)).called(1);
    });
    test('verifyOTP with wrong code updates state to AuthError', () async {
      /// Arrange: First we need to get the controller into the OTPSent state
      /// so that it has a verificationID
      when(
        () =>
            mockAuthRepository.sendOTP(any(), codeSent: any(named: 'codeSent')),
      ).thenAnswer((invocation) async {
        final codeSentCallback =
            invocation.namedArguments[#codeSent] as Function(String, int?);
        codeSentCallback(testVerificationId, null);
      });
      await container
          .read(authControllerProvider.notifier)
          .sendOTP(testPhoneNumber);
      // Now, Arrange for the verification to fail by throwing an exception
      final exception = Exception('Invalid OTP');
      when(
        () => mockAuthRepository.verifyOTP(testVerificationId, 'wrong-code'),
      ).thenThrow(exception);

      /// Act
      await container
          .read(authControllerProvider.notifier)
          .verifyOTP('wrong-code');

      /// Assert
      expect(
        container.read(authControllerProvider),
        AuthError(exception.toString(), AuthMethod.phone),
      );
    });
  });
}

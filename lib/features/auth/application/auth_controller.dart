import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../domain/user_model.dart';
import '../infrastructure/auth_repository.dart';
import 'auth_state.dart';

/// this class is calling auth_repository model functions
///
/// and put user data to hive box and changing state value
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Box<UserModel> _authBox;

  /// Ref use to connect another provider
  final Ref ref;
  String? _verificationId;
  String? _phoneNumber;
  final AppLogger _appLogger;

  /// AuthController Constructor for call outside
  AuthController(this._authRepository, this._authBox, this.ref, this._appLogger)
    : super(const AuthInitial());

  /// Check User is Authenticated need to call in main to check
  void checkInitialAuthState() async {
    final getOnlineUser = await _authRepository.getCurrentUser();
    final user = getOnlineUser ?? _authBox.get('user');
    if (user != null) {
      state = Authenticated(user);
    } else {
      state = const Unauthenticated();
    }
  }

  /// Email & Password SignUp Controller function
  Future<void> signUp(String email, String password, String name) async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.signUp(email, password, name);
      if (user != null) {
        _authBox.put('user', user);
        state = Authenticated(user);
      } else {
        state = const AuthError(
          ' Sign up failed. Please try again.',
          AuthMethod.signup,
        );
      }
    } catch (e) {
      state = AuthError('Sign up failed. Please Try Again', AuthMethod.signup);
    }
  }

  /// Email & Password SignIn Controller function
  Future<void> signIn(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.signIn(email, password);
      if (user != null) {
        await _authBox.put('user', user);
        state = Authenticated(user);
      } else {
        state = const AuthError(
          ' Sign in failed. Please try again.',
          AuthMethod.email,
        );
      }
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.email);
    }
  }

  /// Google SignIn Controller function
  Future<void> signInWithGoogle() async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        _authBox.put('user', user);
        state = Authenticated(user);
      } else {
        state = const AuthError(
          'Google Sign in failed. Please try again.',
          AuthMethod.google,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        state = const AuthError(
          'An account already exists with this email. Please sign in using the provider associated with this email address',
          AuthMethod.google,
        );
      }
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.google);
    }
  }

  /// Google SignIn Controller function
  Future<void> signInWithGithub() async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.signInWithGithub();
      if (user != null) {
        _authBox.put('user', user);
        state = Authenticated(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        state = const AuthError(
          'An account already exists with this email. Please sign in using the provider associated with this email address',
          AuthMethod.github,
        );
      }
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.github);
    }
  }

  /// Forget Password reset mail Controller function
  Future<void> sendPasswordResetEmail(String email) async {
    state = const AuthLoading();
    try {
      await _authRepository.sendPasswordResetEmail(email);
      state = const PasswordResetEmailSent();
      Future.delayed(
        const Duration(seconds: 1),
        () => state = const AuthInitial(),
      );
    } catch (e) {
      state = AuthError(
        'Failed to send reset Email . ${e.toString()}',
        AuthMethod.email,
      );
    }
  }

  /// Sign out controller function
  Future<void> signOut() async {
    state = const AuthLoading();
    try {
      await _authRepository.signOut();
      await _authBox.clear();
      await _authBox.delete('user');
      // Assuming goRouterProvider exists
      state = const AuthInitial();
    } catch (e, s) {
      _appLogger.error('App logger from signout $e \n $s');
    }
  }

  /// Phone authentication Sending OTP
  Future<void> sendOTP(String phoneNumber) async {
    // state = const AuthLoading();
    // state = const AuthLoading();
    _appLogger.debug(
      '🚀 ~ Trying to send OTP from auth controller $phoneNumber',
    );

    try {
      await _authRepository.sendOTP(
        phoneNumber,
        codeSent: (verificationId, resendToken) {
          _appLogger.debug(
            '🚀 ~ Trying to send OTP 1 from auth controller from co d sent start $verificationId , $resendToken',
          );

          _verificationId = verificationId;
          state = const OTPSent();
          _appLogger.debug(
            '🚀 ~ what is the state after cod sent $_verificationId , $state',
          );
        },
      );
      _appLogger.debug('🚀 ~ Trying to send OTP from auth controller');
    } catch (e) {
      _appLogger.debug('🚀 ~ send OTP failed from auth controller');
      state = AuthError(e.toString(), AuthMethod.phone);
    }
  }

  /// Phone authentication verify OTP

  Future<void> verifyOTP(String smsCode) async {
    state = const AuthLoading();
    try {
      if (_verificationId == null) {
        throw Exception('Verification ID is null. Please resend OTP.');
      }
      final user = await _authRepository.verifyOTP(_verificationId!, smsCode);
      if (user != null) {
        _authBox.put('user', user);
        state = Authenticated(user);
      } else {
        state = const AuthError('OTP verification failed', AuthMethod.phone);
      }
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.phone);
    }
  }

  /// Phone authentication if send OTP failed

  Future<void> resendOTP() async {
    state = const AuthLoading();
    try {
      if (_phoneNumber == null) {
        throw Exception('Phone number is null. Please go back and re-enter.');
      }
      await _authRepository.resendOTP(
        _phoneNumber!,
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          state = const OTPSent();
        },
      );
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.phone);
    }
  }
}

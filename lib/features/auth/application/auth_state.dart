import 'package:ai_form_builder/features/auth/domain/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Base class representing the authentication state.
///
/// Extend this to represent specific authentication states such as
/// [AuthInitial], [AuthLoading], [Authenticated], [Unauthenticated], and [AuthError].
@immutable
abstract class AuthState {
  /// get user id from anywhere
  String? get uid =>
      this is Authenticated ? (this as Authenticated).user.uid : null;

  /// Const constructor for [AuthState].

  const AuthState();
}

/// Represents the initial state before any authentication action occurs.
class AuthInitial extends AuthState {
  /// Const constructor for [AuthInitial].
  const AuthInitial();
}

/// Represents the loading state during an authentication process.
class AuthLoading extends AuthState {
  /// Const constructor for [AuthLoading].
  const AuthLoading();
}

/// Represents a successfully authenticated user.
///
/// Contains the [User] object returned by Firebase.
class Authenticated extends AuthState {
  /// The authenticated Firebase [User].
  final UserModel user;

  /// Const constructor for [Authenticated] state with the given [user].
  const Authenticated(this.user);
}

/// Represents a state where the user is not authenticated.
class Unauthenticated extends AuthState {
  /// Const constructor for [Unauthenticated].
  const Unauthenticated();
}

/// Represents an authentication failure with an error [message].
class AuthError extends AuthState {
  /// Error message describing the reason for authentication failure.
  final String message;

  /// Auth Methods
  final AuthMethod method;

  /// Const constructor for [AuthError] with a specific error [message].
  const AuthError(this.message, this.method);
}

/// Represent a state where the password reset email has been sent
class PasswordResetEmailSent extends AuthState {
  /// Const constructor for [PasswordResetEmailSent] to call it outside
  const PasswordResetEmailSent();
}

/// The state when the OTP has been sent.
class OTPSent extends AuthState {
  /// The state when the OTP has been sent.
  const OTPSent();
}

/// Represent a state where the user is signed out
class AuthSignedOut extends AuthState {
  /// Const constructor for [AuthSignedOut] to call it outside
  const AuthSignedOut();
}

/// Enum representing the various authentication methods and states
/// used throughout the application.
enum AuthMethod {
  /// No authentication method is currently selected or used.
  none,

  /// User authentication via email and password.
  email,

  /// User authentication via Google Sign-In.
  google,

  /// User authentication via GitHub OAuth.
  github,

  /// User authentication via Phone.
  phone,

  /// Indicates that the user is currently signing up (registration flow).
  signup,

  /// Indicates that the user has signed out.
  signout,

  /// Indicates that the user is attempting to reset their password.
  forgetPassword,
}

import 'package:ai_form_builder/core/errors/exceptions.dart';
import 'package:ai_form_builder/core/services/hive_service.dart'; // Import HiveService
import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/ai_chat/provider/ai_chat_providers.dart'; // Import aiChatControllerProvider
import 'package:ai_form_builder/features/auth/domain/user_role.dart';
import 'package:ai_form_builder/features/utou_chat/provider/utou_chat_providers.dart'; // Import uToUChatControllerProvider
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // Make sure to add this import
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod Ref
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/user_model.dart';

/// this is the file where auth_controller connect with repositories
class AuthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final Ref _ref; // Add Ref object
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  /// Check Auth State
  AuthRepository(this._ref); // Constructor to receive Ref

  // final _box = Hive.box<UserModel>('authBox');

  /// this is SignUp model function which will call from controller
  Future<UserModel?> signUp(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _saveUserData(
      cred.user!,
      cred.user!.displayName,
      cred.user!.photoURL,
    );
    return UserModel(
      uid: cred.user!.uid,
      email: cred.user!.email!,
      name: cred.user!.displayName,
      photoURL: cred.user!.photoURL,
    );
  }

  /// this is Signin model function which will call from controller
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserData(
        cred.user!,
        cred.user!.displayName,
        cred.user!.photoURL,
      );
      return UserModel(
        uid: cred.user!.uid,
        email: cred.user!.email!,
        photoURL: cred.user!.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw const AuthenticationException(
          '🚀 ~An account already exists with this email. Please sign in using the provider associated with this email address',
        );
      } else {
        /// Handle other Firebase-specific errors
        throw const AuthenticationException('Sign in failed. Please try again');
      }
    } catch (e) {
      throw AuthenticationException(
        '🚀 ~ Email or Password Combination not Match',
      );
    }
  }

  /// This is Signin model function for google signin which will call from controller
  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        /// User canceled the sign-in
        throw AuthenticationException('🚀 ~ User Canceled the Sign-in');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      await _saveUserData(
        cred.user!,
        cred.user!.displayName,
        cred.user!.photoURL,
      );
      return UserModel(
        uid: cred.user!.uid,
        email: cred.user!.email!,
        photoURL: cred.user!.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw const AuthenticationException(
          '🚀 ~An account already exists with this email. Please sign in using the provider associated with this email address',
        );
      } else {
        /// Handle other Firebase-specific errors
        throw const AuthenticationException(
          'Google sign in failed. Please try again',
        );
      }
    } catch (e) {
      AppLogger.error('🚀 ~ Error during Google Sign-in $e');
      throw AuthenticationException('🚀 ~ Google Sign in failed $e');
    }
  }

  /// This is Signin model function for github signin which will call from controller
  Future<UserModel?> signInWithGithub() async {
    try {
      final githubAuthProvider = GithubAuthProvider();
      UserCredential cred;
      if (kIsWeb) {
        cred = await _auth.signInWithPopup(githubAuthProvider);
      } else {
        cred = await _auth.signInWithProvider(githubAuthProvider);
      }
      await _saveUserData(
        cred.user!,
        cred.user!.displayName,
        cred.user!.photoURL,
      );
      return UserModel(
        uid: cred.user!.uid,
        email: cred.user!.email!,
        name: cred.user!.displayName,
        photoURL: cred.user!.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw const AuthenticationException(
          '🚀 ~An account already exists with this email. Please sign in using the provider associated with this email address',
        );
      } else {
        /// Handle other Firebase-specific errors
        throw const AuthenticationException(
          'Github sign in failed. Please try again',
        );
      }
    } catch (e) {
      AppLogger.error('🚀 ~ Error during Github Sign-in', e);
      throw const AuthenticationException(
        '🚀 ~Failed to sign in with GitHub. Please try again.',
      );
    }
  }

  /// Sends a password reset email to the given email address
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      AppLogger.error('🚀 ~ sendPasswordResetEmail Error', e);
      throw const AuthenticationException(
        '🚀 ~Failed to send Password Reset Email',
      );
    }
  }

  /// model function for logout which will call from controller
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await HiveService.clear();
    _ref.invalidate(aiChatControllerProvider);
    _ref.invalidate(uToUChatControllerProvider);
    _ref.invalidate(messagesProvider);

    // Redirect to login screen after logout
  }

  /// OTP send Repository Function
  Future<void> sendOTP(
    String phoneNumber, {
    required Function(String, int?) codeSent,
    Function(String)? codeAutoRetrievalTimeoutCallback,
  }) async {
    AppLogger.debug('🚀send otp called with this number $phoneNumber');

    try {
      AppLogger.debug('🚀send otp called with this number2 $phoneNumber');

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          AppLogger.debug('🚀 Verification completed $codeSent, $credential');
        },
        verificationFailed: (FirebaseAuthException e) {
          AppLogger.debug('🚀 ~Failed to send OTP $e');
          throw AuthenticationException(e.message ?? '🚀 ~Failed to send OTP');
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          AppLogger.debug('🚀 ~Code getting timeout $verificationId');
          codeAutoRetrievalTimeoutCallback?.call(verificationId);
        },
      );
    } catch (e) {
      throw AuthenticationException('🚀 ~Failed to send OTP from cache $e');
    }
  }

  /// Verify OTP auth_Repository Function

  Future<UserModel?> verifyOTP(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final cred = await _auth.signInWithCredential(credential);
      await _saveUserData(
        cred.user!,
        cred.user!.displayName,
        cred.user!.photoURL,
      );
      return UserModel(
        uid: cred.user!.uid,
        email: cred.user!.email!,
        name: cred.user!.displayName,
        photoURL: cred.user!.photoURL,
      );
    } catch (e) {
      throw AuthenticationException('🚀 ~Failed to verify OTP');
    }
  }

  /// Resent OTP auth_Repository Function

  Future<void> resendOTP(
    String phoneNumber, {
    required Function(String, int?) codeSent,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw AuthenticationException(e.message ?? 'Failed to send OTP');
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw AuthenticationException('Failed to resend OTP');
    }
  }

  /// Get User's data from firebase authentication
  Stream<List<UserModel>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return UserModel(
          uid: doc.id,
          email: data['email'] ?? '',
          name: data['displayName'] ?? 'No Name',
          photoURL: data['photoURL'],

          /// Assuming 'role' is also field in your Firestore document
          role: UserRole.values.firstWhere(
            (e) => e.toString() == 'UserRole.${data['role'] ?? 'guest'}',
            orElse: () => UserRole.guest,
          ),
        );
      }).toList();
    });
  }

  Future<void> _saveUserData(
    User user,
    String? displayName,
    String? photoURL,
  ) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();
    final fcmTokens = await FirebaseMessaging.instance.getToken();
    if (!snapshot.exists) {
      await userDoc.set({
        'email': user.email,
        'displayName': displayName ?? user.email,
        'photoURL': photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'fcmTokens': [fcmTokens],
      }, SetOptions(merge: true));
    } else {
      await userDoc.update({
        'fcmTokens': FieldValue.arrayUnion([fcmTokens]),
      });
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await userDoc.update({'fcmTokens': newToken});
    });
  }

  /// get Current uSer info so that can assre user is logged in
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
    }
    return null;
  }
}

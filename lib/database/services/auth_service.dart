import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';
import 'firebase_service.dart';

/// Authentication entry point for the application.
///
/// This layer encapsulates Firebase auth operations and translates low-level
/// Firebase exceptions into user-friendly messages used by the login and
/// registration flows.
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password.
  // This is the primary login path for both managers and employees.
  static Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update online status
      if (credential.user != null) {
        await FirebaseService.updateOnlineStatus(credential.user!.uid, true);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = AppConstants.errorUserNotFound;
          break;
        case 'wrong-password':
          message = AppConstants.errorInvalidCredentials;
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'User account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many failed attempts. Please try again later';
          break;
        default:
          message = 'Authentication failed: ${e.message}';
      }
      throw AuthException(message);
    }
  }

  // Sends a password-reset email after normalizing the address.
  // This keeps input consistent and avoids duplicate or mismatched account lookups.
  static Future<void> sendPasswordResetEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw AuthException('Please enter your email address');
    }
    try {
      await _auth.sendPasswordResetEmail(email: normalizedEmail);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message =
              'No account found with this email address. Please check the spelling or create an account first.';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled. Please contact support.';
          break;
        case 'too-many-requests':
          message =
              'Too many attempts. Please wait a few minutes and try again.';
          break;
        case 'network-request-failed':
          message =
              'Network error. Please check your connection and try again.';
          break;
        case 'operation-not-allowed':
          message =
              'Password reset is not enabled. Please contact support.';
          break;
        default:
          message = 'Password reset failed: ${e.message}';
      }
      throw AuthException(message);
    }
  }

  // Best-effort verification email to the currently signed-in user.
  // Never blocks registration; the user can resend from the verify screen.
  // A failure here only impacts the email delivery, not the auth state itself.
  static Future<void> sendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      debugPrint('Verification email not sent: $e');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await FirebaseService.updateOnlineStatus(user.uid, false);
      }
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

}

// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;

  /// Machine-readable Firebase code (e.g. 'email-already-in-use'), if any.
  final String code;

  AuthException(this.message, {this.code = ''});

  @override
  String toString() => message;
}

/// Maps Firebase registration failures to user-facing messages.
String registrationErrorMessage(FirebaseAuthException e, String operation) {
  switch (e.code) {
    case 'email-already-in-use':
      return 'An account with this email already exists. Please sign in instead — you can resend the verification link from there if needed.';
    case 'weak-password':
      return 'Password is too weak';
    case 'invalid-email':
      return 'Invalid email address';
    default:
      return '$operation: ${e.message}';
  }
}

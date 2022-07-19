import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  final _authStatusStream = StreamController<AuthStatus>();
  AuthStatus _currentStatus = AuthStatus.unauthenticated;

  /// The Stream of [AuthStatus] changes.
  Stream<AuthStatus> get authStatus => _authStatusStream.stream;

  /// Returns the current authentication state as a bool.
  bool get isAuthenticated => _currentStatus == AuthStatus.authenticated;

  /// Initialize the repository with the current state of the
  /// Amplify user session.
  Future<void> initialize() async {
    try {
      AuthSession auth = await Amplify.Auth.fetchAuthSession();
      (auth.isSignedIn) ? _authenticated() : _unauthenticated();
    } catch (_) {
      _unauthenticated();
    }
  }

  /// Signs In the device using the supplied [email] and [password].
  /// If successful the [AuthStatus] is sent on the [authStatus] Stream.
  Future<void> signIn({required String email, required String password}) async {
    SignInResult result;
    try {
      result = await Amplify.Auth.signIn(username: email, password: password);
    } catch (_) {
      _unauthenticated();
      throw SignInFailure();
    }
    if (!result.isSignedIn) {
      _unauthenticated();
      if (result.nextStep != null) {
        throw UnsupportedSignIn();
      }
    } else {
      _authenticated();
    }
  }

  /// Sign Out the currently authenticated user from the device.
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (_) {
      throw SignOutFailure();
    } finally{
      _unauthenticated();
    }
  }

  /// Set the current AuthStatus to authenticated and
  /// add it to the Status Stream.
  void _authenticated() {
    _currentStatus = AuthStatus.authenticated;
    _authStatusStream.add(AuthStatus.authenticated);
  }

  /// Set the current AuthStatus to unauthenticated and
  /// add it to the Status Stream.
  void _unauthenticated() {
    _currentStatus = AuthStatus.unauthenticated;
    _authStatusStream.add(AuthStatus.unauthenticated);
  }
}

class SignInFailure implements Exception {}

class UnsupportedSignIn implements Exception {}

class SignOutFailure implements Exception {}

class ProfileFailure implements Exception {}

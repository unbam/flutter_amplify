import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

import '../models/auth_credentials.dart';

enum AuthFlowStatus { login, signUp, verification, session }

class AuthState {
  AuthState({required this.authFlowStatus});
  final AuthFlowStatus authFlowStatus;
}

class AuthService {
  final authStateController = StreamController<AuthState>();
  late AuthCredentials _credentials;

  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  Future<void> loginWithCredentials(AuthCredentials credentials) async {
    try {
      final result = await Amplify.Auth.signIn(
          username: credentials.username, password: credentials.password);

      if (result.isSignedIn) {
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        debugPrint('User could not be signed in');
      }
    } on AuthException catch (authError) {
      debugPrint('Could not login - ${authError.message}');
    }
  }

  Future<void> signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {'email': credentials.email};

      final result = await Amplify.Auth.signUp(
          username: credentials.username,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      if (result.isSignUpComplete) {
        loginWithCredentials(credentials);
      } else {
        _credentials = credentials;
        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add(state);
      }
    } on AuthException catch (authError) {
      debugPrint('Failed to sign up - ${authError.message}');
    }
  }

  Future<void> verifyCode(String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: _credentials.username, confirmationCode: verificationCode);

      if (result.isSignUpComplete) {
        loginWithCredentials(_credentials);
      } else {
        // Follow more steps
      }
    } on AuthException catch (authError) {
      debugPrint('Could not verify code - ${authError.message}');
    }
  }

  Future<void> logOut() async {
    try {
      await Amplify.Auth.signOut();
      showLogin();
    } on AuthException catch (authError) {
      debugPrint('Could not log out - ${authError.message}');
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      await Amplify.Auth.fetchAuthSession();

      final state = AuthState(authFlowStatus: AuthFlowStatus.session);
      authStateController.add(state);
    } catch (_) {
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
    }
  }
}

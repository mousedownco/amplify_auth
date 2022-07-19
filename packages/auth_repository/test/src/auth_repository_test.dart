import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_auth_plugin_interface/amplify_auth_plugin_interface.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthPlugin extends Mock implements AuthPluginInterface {}

class MockCognitoAuthSession extends Mock implements CognitoAuthSession {}

class MockAWSCognitoUserPoolTokens extends Mock
    implements AWSCognitoUserPoolTokens {}

class FakeSessionRequest extends Fake implements AuthSessionRequest {}

class FakeSignInRequest extends Fake implements SignInRequest {}

class FakeSignOutRequest extends Fake implements SignOutRequest {}

void main() {
  group('AuthRepository', () {
    late AuthRepository authRepository;
    final auth = MockAuthPlugin();

    setUpAll(() {
      registerFallbackValue(FakeSessionRequest());
      registerFallbackValue(FakeSignInRequest());
      when(() => auth.streamController)
          .thenAnswer((_) => StreamController<dynamic>());
      when(auth.addPlugin).thenAnswer((_) async {});
      Amplify.addPlugin(auth);
    });

    setUp(() {
      authRepository = AuthRepository();
    });

    test('defaults', () {
      expect(authRepository.authStatus, isNotNull);
      expect(authRepository.isAuthenticated, false);
    });

    group('initialize', () {
      test('signedIn', () async {
        when(() => auth.fetchAuthSession(request: any(named: 'request')))
            .thenAnswer((_) async => AuthSession(isSignedIn: true));
        await authRepository.initialize();
        expect(authRepository.isAuthenticated, true);
      });
      test('!signedIn', () async {
        when(() => auth.fetchAuthSession(request: any(named: 'request')))
            .thenAnswer((_) async => AuthSession(isSignedIn: false));
        await authRepository.initialize();
        expect(authRepository.isAuthenticated, false);
      });
    });

    group('signIn', () {
      const email = 'mike@example.com';
      const password = 'P@55w0r)!';
      test('isSignedIn == true', () async {
        when(() => auth.signIn(request: any(named: 'request')))
            .thenAnswer((_) async => SignInResult(isSignedIn: true));
        await authRepository.signIn(email: email, password: password);
        expect(authRepository.isAuthenticated, true);
      });
      test('isSignedIn == false', () async {
        when(() => auth.signIn(request: any(named: 'request')))
            .thenAnswer((_) async => SignInResult(isSignedIn: false));
        await authRepository.signIn(email: email, password: password);
        expect(authRepository.isAuthenticated, false);
      });
      test('unsupported signIn', () async {
        when(() => auth.signIn(request: any(named: 'request'))).thenAnswer(
            (_) async => SignInResult(
                isSignedIn: false,
                nextStep: AuthNextSignInStep(signInStep: 'MFA')));
        expect(
            () async =>
                await authRepository.signIn(email: email, password: password),
            throwsA(isA<UnsupportedSignIn>()));
        expect(authRepository.isAuthenticated, false);
      });
      test('cognito exception', () async {
        when(() => auth.signIn(request: any(named: 'request')))
            .thenThrow(PasswordResetRequiredException('mock error'));
        expect(
            () async =>
                await authRepository.signIn(email: email, password: password),
            throwsA(isA<SignInFailure>()));
        expect(authRepository.isAuthenticated, false);
      });
    });

    group('signOut', () {
      setUp(() async {
        when(() => auth.fetchAuthSession(request: any(named: 'request')))
            .thenAnswer((_) async => AuthSession(isSignedIn: true));
        await authRepository.initialize();
      });
      test('success', () async {
        when(() => auth.signOut(request: any(named: 'request')))
            .thenAnswer((_) async => SignOutResult());
        await authRepository.signOut();
        expect(authRepository.isAuthenticated, false);
      });
      test('error', () async {
        when(() => auth.signOut(request: any(named: 'request')))
            .thenThrow(PasswordResetRequiredException('mock error'));
        expect(() async => await authRepository.signOut(),
            throwsA(isA<SignOutFailure>()));
        expect(authRepository.isAuthenticated, false);
      });
    });
  });
}

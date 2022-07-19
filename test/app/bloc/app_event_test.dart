import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/app/app.dart';

void main() {
  group('AppEvent', () {
    group('AppAuthChanged', () {
      test('equal values', () {
        expect(const AppAuthChanged(AuthStatus.authenticated),
            const AppAuthChanged(AuthStatus.authenticated));
      });
      test('unequal values', () {
        expect(const AppAuthChanged(AuthStatus.authenticated),
            isNot(const AppAuthChanged(AuthStatus.unauthenticated)));
      });
    });
    group('AppSignOutRequested', () {
      test('value comparison', () {
        expect(const AppSignOutRequested(), const AppSignOutRequested());
      });
    });
  });
}

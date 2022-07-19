import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/app/app.dart';

void main() {
  group('AppState', () {
    test('authenticated', () {
      const state = AppState.authenticated();
      expect(state.status, AppStatus.authenticated);
    });
    test('unauthenticated', () {
      const state = AppState.unauthenticated();
      expect(state.status, AppStatus.unauthenticated);
    });
    test('value comparison', () {
      expect(const AppState.authenticated(), const AppState.authenticated());
      expect(const AppState.unauthenticated(),
          isNot(const AppState.authenticated()));
    });
  });
}

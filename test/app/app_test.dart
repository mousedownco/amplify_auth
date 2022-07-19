import 'dart:async';

import 'package:amplify_auth/app/app.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('App', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    testWidgets('renders App', (tester) async {
      when(() => authRepository.isAuthenticated).thenReturn(false);
      when(() => authRepository.authStatus)
          .thenAnswer((_) => StreamController<AuthStatus>().stream);
      await tester.pumpWidget(App(authRepository: authRepository));
      expect(find.byType(App), findsOneWidget);
    });
  });
}

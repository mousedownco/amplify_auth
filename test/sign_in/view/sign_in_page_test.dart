import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:amplify_auth/sign_in/sign_in.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('SignInPage', () {
    test('has a page', () {
      expect(SignInPage.page(), isA<MaterialPage>());
    });
    testWidgets('renders SignInForm', (tester) async {
      await tester.pumpWidget(RepositoryProvider<AuthRepository>(
          create: (_) => MockAuthRepository(),
          child: const MaterialApp(home: SignInPage())));
      expect(find.byType(SignInForm), findsOneWidget);
    });
  });
}

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:amplify_auth/app/app.dart';
import 'package:amplify_auth/sign_in/sign_in.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('MxlAppView', () {
    late AuthRepository authRepository;
    late AppBloc appBloc;

    setUp(() {
      authRepository = MockAuthRepository();
      appBloc = MockAppBloc();
    });

    Widget subject() => MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authRepository),
            ],
            child: MaterialApp(
                home: BlocProvider.value(
                    value: appBloc, child: const AppView())));

    testWidgets('navigates to SignIn when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(subject());
      await tester.pumpAndSettle();
      expect(find.byType(SignInPage), findsOneWidget);
    });

    testWidgets('navigates to Home when authenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.authenticated());
      await tester.pumpWidget(subject());
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
  group('onGenerateAppViewPages', () {
    test('SignInPage', () {
      expect(onGenerateAppViewPages(const AppState.unauthenticated(), []),
          [SignInPage.page()]);
    });
    test('HomePage', () {
      expect(onGenerateAppViewPages(const AppState.authenticated(), []),
          [HomePage.page()]);
    });
  });
}

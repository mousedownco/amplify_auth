import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:amplify_auth/app/app.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AppBloc', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
      when(() => authRepository.authStatus)
          .thenAnswer((_) => const Stream.empty());
      when(() => authRepository.isAuthenticated).thenReturn(false);
    });

    test('isAuthenticated is false', () {
      expect(AppBloc(authRepository: authRepository).state,
          const AppState.unauthenticated());
    });
    group('AppAuthChanged', () {
      blocTest<AppBloc, AppState>(
        'AuthStatus.authenticated',
        setUp: () =>
            when(() => authRepository.isAuthenticated).thenReturn(false),
        build: () => AppBloc(authRepository: authRepository),
        act: (bloc) => bloc.add(const AppAuthChanged(AuthStatus.authenticated)),
        expect: () => <AppState>[const AppState.authenticated()],
      );
      blocTest<AppBloc, AppState>(
        'AuthStatus.unauthenticated',
        setUp: () =>
            when(() => authRepository.isAuthenticated).thenReturn(true),
        build: () => AppBloc(authRepository: authRepository),
        act: (bloc) =>
            bloc.add(const AppAuthChanged(AuthStatus.unauthenticated)),
        expect: () => <AppState>[const AppState.unauthenticated()],
      );
    });
    group('AppSignOutRequested', () {
      blocTest<AppBloc, AppState>(
          'calls signOut',
          setUp: () =>
              when(() => authRepository.signOut()).thenAnswer((_) async => {}),
          build: () => AppBloc(authRepository: authRepository),
          act: (bloc) => bloc.add(const AppSignOutRequested()),
          verify: (_) {
            verify(() => authRepository.signOut()).called(1);
          });
    });
  });
}

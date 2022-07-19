import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:amplify_auth/sign_in/sign_in.dart';

import '../../testdata/testdata.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('SignInBloc', () {
    late AuthRepository authRepository;
    late SignInState validPasswordState;
    late SignInState validEmailState;

    setUp(() {
      authRepository = MockAuthRepository();
      validEmailState = const SignInState(email: Email.dirty(testEmail));
      validPasswordState =
          const SignInState(password: Password.dirty(testPassword));
    });

    test('initial state', () {
      expect(SignInBloc(authRepository).state, const SignInState());
    });

    group('SignInEmailChanged', () {
      blocTest<SignInBloc, SignInState>(
        'valid email',
        seed: () => validPasswordState,
        build: () => SignInBloc(authRepository),
        act: (bloc) => bloc.add(const SignInEmailChanged(testEmail)),
        expect: () => <SignInState>[
          validPasswordState.copyWith(
              status: FormzStatus.valid, email: const Email.dirty(testEmail))
        ],
      );
      blocTest<SignInBloc, SignInState>(
        'invalid email',
        seed: () => validPasswordState,
        build: () => SignInBloc(authRepository),
        act: (bloc) => bloc.add(const SignInEmailChanged('')),
        expect: () => <SignInState>[
          validPasswordState.copyWith(
              status: FormzStatus.invalid, email: const Email.dirty(''))
        ],
      );
    });
    group('SignInPasswordChanged', () {
      blocTest<SignInBloc, SignInState>(
        'valid password',
        seed: () => validEmailState,
        build: () => SignInBloc(authRepository),
        act: (bloc) => bloc.add(const SignInPasswordChanged(testPassword)),
        expect: () => <SignInState>[
          validEmailState.copyWith(
              status: FormzStatus.valid,
              password: const Password.dirty(testPassword))
        ],
      );
      blocTest<SignInBloc, SignInState>(
        'invalid password',
        seed: () => validEmailState,
        build: () => SignInBloc(authRepository),
        act: (bloc) => bloc.add(const SignInPasswordChanged('')),
        expect: () => <SignInState>[
          validEmailState.copyWith(
              status: FormzStatus.invalid, password: const Password.dirty(''))
        ],
      );
    });
    group('SignInSubmitted', () {
      blocTest<SignInBloc, SignInState>('valid form success',
          setUp: () => when(() => authRepository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'))).thenAnswer((_) async => {}),
          seed: () => const SignInState(
              status: FormzStatus.valid,
              email: Email.dirty(testEmail),
              password: Password.dirty(testPassword)),
          build: () => SignInBloc(authRepository),
          act: (bloc) => bloc.add(const SignInSubmitted()),
          verify: (_) => verify(() => authRepository.signIn(
              email: testEmail, password: testPassword)).called(1),
          expect: () => <SignInState>[
                const SignInState(
                    status: FormzStatus.submissionInProgress,
                    email: Email.dirty(testEmail),
                    password: Password.dirty(testPassword)),
                const SignInState(
                    status: FormzStatus.submissionSuccess,
                    email: Email.dirty(testEmail),
                    password: Password.dirty(testPassword)),
              ]);
      blocTest<SignInBloc, SignInState>('valid form with sign in failure',
          setUp: () => when(() => authRepository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'))).thenThrow(SignInFailure()),
          seed: () => const SignInState(
              status: FormzStatus.valid,
              email: Email.dirty(testEmail),
              password: Password.dirty(testPassword)),
          build: () => SignInBloc(authRepository),
          act: (bloc) => bloc.add(const SignInSubmitted()),
          expect: () => <SignInState>[
                const SignInState(
                    status: FormzStatus.submissionInProgress,
                    email: Email.dirty(testEmail),
                    password: Password.dirty(testPassword)),
                const SignInState(
                    status: FormzStatus.submissionFailure,
                    email: Email.dirty(testEmail),
                    password: Password.dirty(testPassword)),
              ]);
      blocTest<SignInBloc, SignInState>(
        'invalid form',
        seed: () => const SignInState(
            status: FormzStatus.invalid,
            email: Email.dirty(testEmail),
            password: Password.dirty(testPassword)),
        build: () => SignInBloc(authRepository),
        act: (bloc) => bloc.add(const SignInSubmitted()),
        verify: (_) => verifyNever(()=>
            authRepository.signIn(email: testEmail, password: testPassword)),
        expect: () => <SignInState>[],
      );
    });
  });
}

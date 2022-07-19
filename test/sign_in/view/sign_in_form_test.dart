import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:amplify_auth/sign_in/sign_in.dart';

import '../../testdata/testdata.dart';

class MockSignInBloc extends MockBloc<SignInEvent, SignInState>
    implements SignInBloc {}

class MockEmail extends Mock implements Email {}

class MockPassword extends Mock implements Password {}

class FakeSignInState extends Fake implements SignInState {}

void main() {
  const emailInputKey = Key('signInForm_emailInput_textField');
  const passwordInputKey = Key('signInForm_passwordInput_textField');
  const signInButtonKey = Key('signInForm_signIn_raisedButton');

  group('SignInForm', () {
    late SignInBloc signInBloc;

    setUp(() {
      signInBloc = MockSignInBloc();
      when(() => signInBloc.state).thenReturn(const SignInState());
    });

    Widget subject() => MaterialApp(
        home: Scaffold(
            body: BlocProvider.value(
                value: signInBloc, child: const SignInForm())));

    group('events', () {
      testWidgets('SignInEmailChanged when email updated', (tester) async {
        await tester.pumpWidget(subject());
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(() => signInBloc.add(const SignInEmailChanged(testEmail)));
      });
      testWidgets('SignInPasswordChanged when password updated',
          (tester) async {
        await tester.pumpWidget(subject());
        await tester.enterText(find.byKey(passwordInputKey), testPassword);
        verify(() => signInBloc.add(const SignInPasswordChanged(testPassword)));
      });
      testWidgets('SignInSubmitted when button clicked', (tester) async {
        when(() => signInBloc.state)
            .thenReturn(const SignInState(status: FormzStatus.valid));
        await tester.pumpWidget(subject());
        await tester.tap(find.byKey(signInButtonKey));
        verify(() => signInBloc.add(const SignInSubmitted()));
      });
    });
    group('renders', () {
      testWidgets('SignInFailure SnackBar on failure', (tester) async {
        whenListen(
            signInBloc,
            Stream.fromIterable(const <SignInState>[
              SignInState(status: FormzStatus.submissionInProgress),
              SignInState(status: FormzStatus.submissionFailure)
            ]));
        await tester.pumpWidget(subject());
        await tester.pump();
        expect(find.text('Sign In Failure'), findsOneWidget);
      });
      testWidgets('Invalid Email on invalid email field', (tester) async {
        final email = MockEmail();
        when(() => email.invalid).thenReturn(true);
        when(() => signInBloc.state).thenReturn(SignInState(email: email));
        await tester.pumpWidget(subject());
        expect(find.text('Invalid Email'), findsOneWidget);
      });
      testWidgets('Invalid Password on invalid password field', (tester) async {
        final password = MockPassword();
        when(() => password.invalid).thenReturn(true);
        when(() => signInBloc.state)
            .thenReturn(SignInState(password: password));
        await tester.pumpWidget(subject());
        expect(find.text('Invalid Password'), findsOneWidget);
      });
      testWidgets('disabled Sign In button when not valid', (tester) async {
        when(() => signInBloc.state)
            .thenReturn(const SignInState(status: FormzStatus.invalid));
        await tester.pumpWidget(subject());
        final signInButton  = tester.widget<ElevatedButton>(find. byKey(signInButtonKey));
        expect(signInButton.enabled, false);
      });
      testWidgets('enabled Sign In button when valid', (tester) async {
        when(() => signInBloc.state)
            .thenReturn(const SignInState(status: FormzStatus.valid));
        await tester.pumpWidget(subject());
        final signInButton  = tester.widget<ElevatedButton>(find. byKey(signInButtonKey));
        expect(signInButton.enabled, true);
      });
    });
  });
}

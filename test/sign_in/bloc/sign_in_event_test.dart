import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/sign_in/bloc/sign_in_bloc.dart';

import '../../testdata/testdata.dart';

void main() {
  group('SignInEvent', () {
    group('SignInEmailChanged', () {
      test('equal values', () {
        expect(const SignInEmailChanged(testEmail),
            const SignInEmailChanged(testEmail));
      });
      test('unequal values', () {
        expect(const SignInEmailChanged('joe@example.com'),
            isNot(const SignInEmailChanged('bill@example.com')));
      });
    });
    group('SignInPasswordChanged', (){
      test('equal values', () {
        expect(const SignInPasswordChanged(testPassword),
            const SignInPasswordChanged(testPassword));
      });
      test('unequal values', () {
        expect(const SignInPasswordChanged('password123'),
            isNot(const SignInPasswordChanged('123password')));
      });
    });
    group('SignInSubmitted', (){
      test('equal values', (){
        expect(const SignInSubmitted(),
            const SignInSubmitted());
      });
      test('unequal values', (){
        expect(const SignInSubmitted(),
            isNot(const SignInPasswordChanged('')));
      });
    });
  });
}

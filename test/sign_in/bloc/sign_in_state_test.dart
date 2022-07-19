import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:amplify_auth/sign_in/sign_in.dart';

import '../../testdata/testdata.dart';

void main() {
  group('SignInState', () {
    test('pure', () {
      const pure = SignInState();
      expect(pure.status, FormzStatus.pure);
      expect(pure.email, const Email.pure());
      expect(pure.password, const Password.pure());
    });
    test('equal values', () {
      expect(const SignInState(), const SignInState());
    });
    <String, SignInState>{
      'status': const SignInState(status: FormzStatus.invalid),
      'email': const SignInState(email: Email.dirty(testEmail)),
      'password': const SignInState(password: Password.dirty(testPassword))
    }.forEach((key, value) {
      test('$key unequal values', () {
        expect(value, isNot(const SignInState()));
      });
    });
  });
}

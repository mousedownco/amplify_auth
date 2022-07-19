import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/sign_in/sign_in.dart';

import '../../testdata/testdata.dart';

void main() {
  group('Password', () {
    test('pure', () {
      const pure = Password.pure();
      expect(pure.pure, true);
      expect(pure.value, isEmpty);
    });
    test('dirty', () {
      const dirty = Password.dirty(testPassword);
      expect(dirty.pure, false);
      expect(dirty.value, testPassword);
    });
    group('validator', () {
      <String?, PasswordValidationError?>{
        'abcd1234': null,
        'abcd12345': null,
        'abcd123': PasswordValidationError.length,
        ' ': PasswordValidationError.length,
        null: PasswordValidationError.empty,
        '': PasswordValidationError.empty
      }.forEach((password, expected) {
        test("'$password' password validation", () {
          expect(const Password.pure().validator(password), expected);
        });
      });
    });
  });
}

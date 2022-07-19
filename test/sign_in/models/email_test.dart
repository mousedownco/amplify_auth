import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/sign_in/sign_in.dart';

import '../../testdata/testdata.dart';

void main(){
  group('Email', (){
    test('pure', (){
      const pure = Email.pure();
      expect(pure.pure, true);
      expect(pure.value, isEmpty);
    });
    test('dirty', (){
      const dirty = Email.dirty(testEmail);
      expect(dirty.pure, false);
      expect(dirty.value, testEmail);
    });
    group('validator', (){
      <String, EmailValidationError?>{
        'test@example.com': null,
        ' space@example.com': null,
        'dot.test_underscore@example.com': null,
        'test': EmailValidationError.invalid,
        '': EmailValidationError.invalid
      }.forEach((email, expected) {
        test("'$email' email validation", (){
          expect(const Email.pure().validator(email), expected);
        });
      });
    });
  });
}
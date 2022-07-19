import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  length,
  // numbers,
  // special,
  // uppercase,
  // lowercase
}

/// The [Password] input validates the length of any entries.
/// It does NOT validate for required character types as this
/// is only used to log in (not to create or change passwords).
class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < _minLength) {
      return PasswordValidationError.length;
    }
    return null;
  }

  static const int _minLength = 8;
// static final RegExp _numbersRegExp = RegExp('(?=.*[0-9])');
// static final RegExp _specialCharacterRegExp = RegExp('(?=.*[-*`~!@#\$%^&()_=+[\\]{}\\\\|;:\'",<>./?€’“”«»–¿¡—฿¥£])');
// static final RegExp _uppercaseRegExp = RegExp('(?=.*[A-ZÀ-Þ])');
// static final RegExp _lowercaseRegExp = RegExp('(?=.*[a-zß-ÿ])');
}

import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

/// The [Email] form field validates any entries against
/// a commonly used email [RegExp]
class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');

  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String? value) {
    return _emailRegExp.hasMatch(value?.trim() ?? '')
        ? null
        : EmailValidationError.invalid;
  }

  /// The following regular expression is borrowed from the Angular library
  /// and is governed by license as described.
  ///
  /// Copyright Google LLC All Rights Reserved.
  ///
  /// Use of this source code is governed by an MIT-style license that can be
  /// found in the LICENSE file at https://angular.io/license
  ///
  /// A regular expression that matches valid e-mail addresses.
  ///
  /// At a high level, this regexp matches e-mail addresses of the format `local-part@tld`, where:
  /// - `local-part` consists of one or more of the allowed characters (alphanumeric and some
  ///   punctuation symbols).
  /// - `local-part` cannot begin or end with a period (`.`).
  /// - `local-part` cannot be longer than 64 characters.
  /// - `tld` consists of one or more `labels` separated by periods (`.`). For example `localhost` or
  ///   `foo.com`.
  /// - A `label` consists of one or more of the allowed characters (alphanumeric, dashes (`-`) and
  ///   periods (`.`)).
  /// - A `label` cannot begin or end with a dash (`-`) or a period (`.`).
  /// - A `label` cannot be longer than 63 characters.
  /// - The whole address cannot be longer than 254 characters.
  ///
  /// ## Implementation background
  ///
  /// This regexp was ported over from AngularJS (see there for git history):
  /// https://github.com/angular/angular.js/blob/c133ef836/src/ng/directive/input.js#L27
  /// It is based on the
  /// [WHATWG version](https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address) with
  /// some enhancements to incorporate more RFC rules (such as rules related to domain names and the
  /// lengths of different parts of the address). The main differences from the WHATWG version are:
  ///   - Disallow `local-part` to begin or end with a period (`.`).
  ///   - Disallow `local-part` length to exceed 64 characters.
  ///   - Disallow total address length to exceed 254 characters.
  ///
  /// See [this commit](https://github.com/angular/angular.js/commit/f3f5cf72e) for more details.
  static final RegExp _emailRegExp = RegExp(
      r"^(?=.{1,254}$)(?=.{1,64}@)[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
}

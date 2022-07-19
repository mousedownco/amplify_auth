part of 'sign_in_bloc.dart';

@immutable
class SignInState extends Equatable {
  const SignInState(
      {this.status = FormzStatus.pure,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  final FormzStatus status;
  final Email email;
  final Password password;

  SignInState copyWith({
    FormzStatus? status,
    Email? email,
    Password? password,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [status, email, password];
}

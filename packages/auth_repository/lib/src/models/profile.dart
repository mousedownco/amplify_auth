import 'package:equatable/equatable.dart';

/// Profile represents the currently authenticated user
/// and is used to display the [account], [name] and
/// [email].
class Profile extends Equatable {
  const Profile({
    required this.account,
    required this.name,
    required this.email,
  });

  /// Create a [Profile] from a JWT token.
  factory Profile.fromJwt(Map<String, dynamic> jwt) {
    return Profile(
        account: jwt['mxl_acct'] ?? '',
        name: jwt['name'] ?? '',
        email: jwt['email'] ?? '');
  }

  static const empty = Profile(account: '', name: '', email: '');

  final String account;
  final String name;
  final String email;

  @override
  List<Object> get props => [account, name, email];
}

part of 'app_bloc.dart';

/// [AppStatus] specifies the authenticated state of the user.
enum AppStatus { authenticated, unauthenticated }

@immutable
class AppState extends Equatable {
  /// Private constructor to prevent use outside of this class
  const AppState._({required this.status});

  const AppState.authenticated() : this._(status: AppStatus.authenticated);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;

  @override
  List<Object> get props => [status];
}

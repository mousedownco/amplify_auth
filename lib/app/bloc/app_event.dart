part of 'app_bloc.dart';

@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();
}

/// The [AuthStatus] for the current user has changed.
class AppAuthChanged extends AppEvent {
  const AppAuthChanged(this.status);

  final AuthStatus status;

  @override
  List<Object> get props => [status];
}

/// The User has requested to be Signed Out
class AppSignOutRequested extends AppEvent {
  const AppSignOutRequested();

  @override
  List<Object> get props => [];
}

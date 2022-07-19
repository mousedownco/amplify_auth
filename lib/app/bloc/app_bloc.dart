import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

/// The AppBloc maintains the authentication state of the
/// application.
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(authRepository.isAuthenticated
            ? const AppState.authenticated()
            : const AppState.unauthenticated()) {
    on<AppAuthChanged>(_onAuthChanged);
    on<AppSignOutRequested>(_onSignOutRequested);
    _authStatusSubscription = _authRepository.authStatus
        .listen((authStatus) => add(AppAuthChanged(authStatus)));
  }

  final AuthRepository _authRepository;
  late final StreamSubscription _authStatusSubscription;

  void _onAuthChanged(AppAuthChanged event, Emitter<AppState> emit) {
    emit(event.status == AuthStatus.authenticated
        ? const AppState.authenticated()
        : const AppState.unauthenticated());
  }

  void _onSignOutRequested(AppSignOutRequested event, Emitter<AppState> emit) {
    unawaited(_authRepository.signOut());
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }
}

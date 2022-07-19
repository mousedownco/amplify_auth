import 'dart:async';
import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth/app/app.dart';

/// Initialize services and prepare them to be injected/provided to
/// the widgets in [App].
void bootstrap({required String amplifyConfig}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Amplify.addPlugin(AmplifyAuthCognito());
  await Amplify.configure(amplifyConfig);
  final AuthRepository authRepository = AuthRepository();
  await authRepository.initialize();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };


  runZonedGuarded(
    () async {
      BlocOverrides.runZoned(
        () => runApp(
          App(authRepository: authRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

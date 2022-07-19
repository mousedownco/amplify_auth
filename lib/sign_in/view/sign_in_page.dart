import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amplify_auth/sign_in/sign_in.dart';

/// The [SignInPage] is the first page presented to users
/// when the launch the app and are not signed in.
class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage(child: SignInPage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amplify Auth'),
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Sign In',
                  textAlign: TextAlign.left,
                  style: textTheme.headline5,
                ),
                const SizedBox(height: 16),
                BlocProvider(
                  create: (_) => SignInBloc(context.read<AuthRepository>()),
                  child: const SignInForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

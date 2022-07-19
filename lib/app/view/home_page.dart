import 'package:amplify_auth/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The [HomePage] provides a read-only view of the currently
/// authenticated user including their account number.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar( title: const Text('Home')),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircleAvatar(
              radius: 48.0,
              child: Icon(
                Icons.person_outline,
                size: 48.0,
              ),
            ),
            const SizedBox(height: 24),
            Text('Signed In', style: textTheme.headline5),
            ElevatedButton(
              key: const Key('sign_out_button'),
              child: const Text('Sign Out'),
              onPressed: () =>
                  context.read<AppBloc>().add(const AppSignOutRequested()),
            )
          ],
        ),
      ),
    );
  }
}

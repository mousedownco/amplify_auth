import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amplify_auth/app/app.dart';
import 'package:amplify_auth/sign_in/sign_in.dart';

/// The [AppView] is the parent [Widget] for the [FlowBuilder]
/// managing the applications primary flow.  All flows should be
/// built on top of this one.
class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlowBuilder<AppState>(
        state: context.select((AppBloc bloc) => bloc.state),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}

List<Page> onGenerateAppViewPages(AppState state, List<Page<dynamic>> pages) {
  if (state.status != AppStatus.authenticated) {
    return [SignInPage.page()];
  } else {
    return [HomePage.page()];
  }
}

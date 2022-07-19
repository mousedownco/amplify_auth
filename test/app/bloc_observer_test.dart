import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:amplify_auth/app/app.dart';

class FakeBloc extends Fake implements Bloc<Object, Object> {}

class FakeEvent extends Fake implements Object {}

class FakeStackTrace extends Fake implements StackTrace {}

class FakeChange extends Fake implements Change {}

class MockTransition extends Mock implements Transition {}

final logs = <String>[];

void main() {
  group('AppBlocObserver', () {
    late Transition transition;
    setUp(() {
      transition = MockTransition();
      logs.clear();
    });

    test('onEvent prints event', overridePrint(() {
      final bloc = FakeBloc();
      final event = FakeEvent();
      AppBlocObserver().onEvent(bloc, event);
      expect(logs, equals(['eee $event']));
    }));

    test('onError prints error', overridePrint(() {
      final bloc = FakeBloc();
      final error = Object();
      final stackTrace = FakeStackTrace();
      AppBlocObserver().onError(bloc, error, stackTrace);
      expect(logs, equals(['$error']));
    }));

    // test('onChange prints change', overridePrint(() {
    //   final bloc = FakeBloc();
    //   final change = FakeChange();
    //   AppBlocObserver().onChange(bloc, change);
    //   expect(logs, equals(['$change']));
    // }));

    test('onTransition prints transition', overridePrint(() {
      when(() => transition.currentState).thenReturn('CURRENT');
      when(() => transition.nextState).thenReturn('NEXT');
      final bloc = FakeBloc();
      AppBlocObserver().onTransition(bloc, transition);
      expect(
          logs,
          equals([
            '### ${transition.currentState}',
            '>>> ${transition.nextState}'
          ]));
    }));
  });
}

void Function() overridePrint(void Function() testFn) {
  return () {
    final spec =
        ZoneSpecification(print: (_, __, ___, String msg) => logs.add(msg));
    return Zone.current.fork(specification: spec).run<void>(testFn);
  };
}

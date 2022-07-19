import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/amplify_json.dart';

void main() {
  group('amplifyJson', () {
    test('poolId', () {
      expect(amplifyJson(poolId: 'poolId', appClientId: '', region: ''),
          contains('"PoolId": "poolId"'));
    });
    test('appClientId', () {
      expect(amplifyJson(poolId: '', appClientId: 'appClientId', region: ''),
          contains('"AppClientId": "appClientId"'));});
    test('region', () {
      expect(amplifyJson(poolId: '', appClientId: '', region: 'us-east-2'),
          contains('"Region": "us-east-2"'));});
  });
}

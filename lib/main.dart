import 'package:amplify_auth/amplify_json.dart';
import 'package:amplify_auth/bootstrap.dart';

/// TODO: Replace with real Cognito Configs
String amplifyConfig = amplifyJson(
  poolId: 'us-east-2_ABCDE123456',
  appClientId: '1234abcd5678efgh9012ijkl',
  region: 'us-east-2',
);

/// DEVELOPMENT main function.
Future<void> main() async {
  bootstrap(amplifyConfig: amplifyConfig);
}
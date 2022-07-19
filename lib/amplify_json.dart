String amplifyJson(
    {required String poolId,
    required String appClientId,
    required String region}) {
  return '''{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {
          "Default": {}
        },
        "CredentialsProvider": {
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "$poolId",
            "AppClientId": "$appClientId",
            "Region": "$region"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH"
          }
        }
      }
    }
  }
}''';
}

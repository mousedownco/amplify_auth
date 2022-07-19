import 'package:auth_repository/auth_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Profile', () {
    test('empty', () {
      const empty = Profile.empty;
      expect(empty.account, isEmpty);
      expect(empty.name, isEmpty);
      expect(empty.email, isEmpty);
    });
    group('fromJwt', () {
      test('empty', () {
        Profile profile = Profile.fromJwt(const {});
        expect(profile, Profile.empty);
      });
      test('populated', () {
        const acct = '123412341234';
        const email = 'mike@example.com';
        const name = 'Mike Dee';
        Profile profile = Profile.fromJwt(
            const <String, dynamic>{
              'mxl_acct': acct,
              'email': email,
              'name': name
            });
        expect(profile.account, acct);
        expect(profile.email, email);
        expect(profile.name, name);
      });
    });
  });
}
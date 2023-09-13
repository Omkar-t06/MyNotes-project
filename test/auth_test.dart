import 'package:mynotes/service/auth/auth_exception.dart';
import 'package:mynotes/service/auth/auth_provider.dart';
import 'package:mynotes/service/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Shoukd not be initialized to brgin with', () {
      expect(provider.isInitialized, false);
    });
    test("Can not log out if not initialized", () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test('Should be able to initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('User should be null after initialized', () {
      expect(provider.currentUser, null);
    });
    test(
      'Should be initialized in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('Create user should be delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'jelly@bean.com',
        password: 'xyz12355',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser =
          provider.createUser(email: 'sth@sth.com', password: 'sthsth12');
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WeakPasswordAuthExceptions>()));
      final user =
          await provider.createUser(email: 'using', password: 'sthson');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Loggin user should be able to verifiy', () async {
      provider.sendVerificationEmail();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user?.isEmailVerified, true);
    });
    test("Should login and logout again n again", () async {
      provider.logout();
      provider.login(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    Future.delayed(const Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == 'foobar@gmail.com') throw UserNotFoundAuthException();
    if (password == 'fonball') throw WrongPasswordAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'foo@baz.com',
      id: 'user_id',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    if (!_isInitialized) throw NotInitializedException();
    _user = null;
  }

  @override
  Future<void> sendVerificationEmail() async {
    if (!_isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser =
        AuthUser(isEmailVerified: true, email: 'foo@bar.com', id: 'my_id');
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}

import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firebase/auth_service.dart';
import 'user_repository.dart';

/// Coordinates authentication. Guests use anonymous auth so Firestore reads
/// still work; logging in / registering moves them to an email account.
class AuthRepository {
  AuthRepository({AuthService? authService, UserRepository? userRepository})
      : _auth = authService ?? AuthService(),
        _users = userRepository ?? UserRepository();

  final AuthService _auth;
  final UserRepository _users;

  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// True only for a real (non-anonymous) account.
  bool get isLoggedIn =>
      _auth.currentUser != null && !_auth.currentUser!.isAnonymous;

  /// Ensures there is a Firebase session, signing in as an anonymous guest if
  /// none exists. Returns the current user.
  Future<User> ensureSession() async {
    final existing = _auth.currentUser;
    if (existing != null) return existing;
    final credential = await _auth.signInAnonymously();
    return credential.user!;
  }

  Future<User> login(String email, String password) async {
    final credential = await _auth.signInWithEmail(email.trim(), password);
    final user = credential.user!;
    await _users.saveUser(uid: user.uid, email: user.email);
    return user;
  }

  /// Registers a new email account. If the user is currently an anonymous
  /// guest, the credential is linked to keep their uid and existing bookings.
  Future<User> register(String email, String password) async {
    final current = _auth.currentUser;
    final credential = (current != null && current.isAnonymous)
        ? await _auth.linkEmail(email.trim(), password)
        : await _auth.registerWithEmail(email.trim(), password);
    final user = credential.user!;
    await _users.saveUser(uid: user.uid, email: user.email);
    return user;
  }

  /// Signs out of the email account and returns to an anonymous guest session.
  Future<User> logout() async {
    await _auth.signOut();
    final credential = await _auth.signInAnonymously();
    return credential.user!;
  }
}

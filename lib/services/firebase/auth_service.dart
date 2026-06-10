import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper over FirebaseAuth. This is the Firebase services layer for
/// authentication — the only place raw FirebaseAuth calls live. Repositories
/// depend on this, not on FirebaseAuth directly.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();

  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> registerWithEmail(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  /// Upgrades the current anonymous user to an email account, preserving the
  /// uid (and therefore any bookings already made as a guest).
  Future<UserCredential> linkEmail(String email, String password) {
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    return _auth.currentUser!.linkWithCredential(credential);
  }

  Future<void> signOut() => _auth.signOut();
}

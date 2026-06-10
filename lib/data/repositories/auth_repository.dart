import 'package:firebase_auth/firebase_auth.dart';

/// Wraps FirebaseAuth for anonymous sign-in. Anonymous auth is enough to
/// satisfy the `isSignedIn()` security rule and to scope bookings to a user.
class AuthRepository {
  AuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  /// Signs in anonymously and returns the user. Reuses the existing session if
  /// one is already active.
  Future<User> signInAnonymously() async {
    final existing = _auth.currentUser;
    if (existing != null) return existing;

    final credential = await _auth.signInAnonymously();
    return credential.user!;
  }

  Future<void> signOut() => _auth.signOut();
}

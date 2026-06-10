import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';

enum AuthStatus { checking, ready }

/// App-wide auth state. Bootstraps a session (anonymous guest if none), and
/// drives login / register / logout. Form screens watch [isSubmitting] and
/// [formError].
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository) {
    _bootstrap();
  }

  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.checking;
  User? _user;
  bool _isSubmitting = false;
  String? _formError;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get userId => _user?.uid;
  String? get email => _user?.email;

  bool get isLoggedIn => _user != null && !_user!.isAnonymous;
  bool get isGuest => _user == null || _user!.isAnonymous;
  bool get isSubmitting => _isSubmitting;
  String? get formError => _formError;

  Future<void> _bootstrap() async {
    try {
      _user = await _repository.ensureSession();
    } catch (_) {
      _user = _repository.currentUser;
    }
    _status = AuthStatus.ready;
    notifyListeners();
  }

  /// Re-runs session bootstrap (used by the error retry on the gate).
  Future<void> retry() {
    _status = AuthStatus.checking;
    notifyListeners();
    return _bootstrap();
  }

  Future<bool> login(String email, String password) =>
      _submit(() => _repository.login(email, password));

  Future<bool> register(String email, String password) =>
      _submit(() => _repository.register(email, password));

  Future<void> logout() async {
    _user = await _repository.logout();
    notifyListeners();
  }

  void clearFormError() => _formError = null;

  Future<bool> _submit(Future<User> Function() action) async {
    _isSubmitting = true;
    _formError = null;
    notifyListeners();

    var success = false;
    try {
      _user = await action();
      success = true;
    } on FirebaseAuthException catch (e) {
      _formError = _messageForCode(e.code);
    } catch (_) {
      _formError = 'Something went wrong. Please try again.';
    }

    _isSubmitting = false;
    notifyListeners();
    return success;
  }

  String _messageForCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
      case 'credential-already-in-use':
        return 'This email is already registered. Please log in.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

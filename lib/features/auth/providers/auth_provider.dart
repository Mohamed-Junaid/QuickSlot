import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';

enum AuthStatus { initial, authenticating, authenticated, error }

/// Drives anonymous sign-in and exposes the current user id to the rest of the
/// app (bookings will read [userId] to scope and authorize writes).
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.initial;
  String? _userId;
  String? _errorMessage;

  AuthStatus get status => _status;
  String? get userId => _userId;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Signs in anonymously, reusing any existing session.
  Future<void> signIn() async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.signInAnonymously();
      _userId = user.uid;
      _status = AuthStatus.authenticated;
    } catch (_) {
      _userId = null;
      _errorMessage = 'Could not sign in. Please try again.';
      _status = AuthStatus.error;
    }

    notifyListeners();
  }
}

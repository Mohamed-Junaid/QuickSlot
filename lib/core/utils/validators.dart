/// Reusable form validators for the auth screens. Return null when valid, or an
/// error message to display under the field.
class Validators {
  Validators._();

  static final RegExp _emailRegExp =
      RegExp(r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required.';
    if (!_emailRegExp.hasMatch(v)) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required.';
    if (v.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please confirm your password.';
    if (v != original) return 'Passwords do not match.';
    return null;
  }
}

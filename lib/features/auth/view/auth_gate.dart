import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/app_error_view.dart';
import '../../navigation/view/main_navigation.dart';
import '../../splash/view/splash_view.dart';
import '../providers/auth_provider.dart';

/// Routes based on auth state. The [AuthProvider] is provided at the app root
/// (see main.dart) so pushed login/register routes can reach it too.
///
/// Keying [MainNavigation] by uid recreates its per-user providers when the
/// signed-in user changes (login switches accounts, logout returns to guest).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {
      case AuthStatus.checking:
        return const SplashView();

      case AuthStatus.ready:
        final userId = auth.userId;
        if (userId == null) {
          return Scaffold(
            body: AppErrorView(
              message: 'Could not start a session.',
              onRetry: auth.retry,
            ),
          );
        }
        return MainNavigation(key: ValueKey(userId), userId: userId);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../venues/view/venue_list_page.dart';
import '../providers/auth_provider.dart';

/// App entry gate. Signs in anonymously, then shows the venue list. Until
/// authenticated, Firestore reads would fail the `isSignedIn()` rule, so the
/// gate blocks the UI behind sign-in.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(AuthRepository())..signIn(),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          switch (auth.status) {
            case AuthStatus.initial:
            case AuthStatus.authenticating:
              return const Scaffold(
                body: AppLoader(message: 'Signing in'),
              );

            case AuthStatus.error:
              return Scaffold(
                body: AppErrorView(
                  message: auth.errorMessage ?? 'Could not sign in.',
                  onRetry: auth.signIn,
                ),
              );

            case AuthStatus.authenticated:
              return const VenueListPage();
          }
        },
      ),
    );
  }
}

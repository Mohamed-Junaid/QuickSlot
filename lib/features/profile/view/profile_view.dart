import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/view/login_page.dart';
import '../../auth/view/register_page.dart';
import '../../bookings/providers/bookings_provider.dart';
import '../../home/widgets/quick_stats.dart';

/// Profile tab. Shows account info + stats + logout when logged in, or a sign-in
/// prompt with benefits when browsing as a guest.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: auth.isLoggedIn
          ? const _LoggedInProfile()
          : const _GuestProfile(),
    );
  }
}

// ---------------------------------------------------------------------------
// Logged in
// ---------------------------------------------------------------------------

class _LoggedInProfile extends StatelessWidget {
  const _LoggedInProfile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final auth = context.watch<AuthProvider>();
    final bookings = context.watch<BookingsProvider>();
    final email = auth.email ?? 'Account';

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: cs.primary,
            child: Text(
              email.substring(0, 1).toUpperCase(),
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Text(
            email,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Account',
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Column(
            children: [
              _InfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: email,
              ),
              const Divider(height: 1),
              const _InfoTile(
                icon: Icons.verified_user_outlined,
                label: 'Status',
                value: 'Signed in',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Your activity',
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        QuickStats(
          totalBookings: bookings.activeCount,
          upcomingBookings: bookings.upcomingCount,
        ),
        const SizedBox(height: AppSpacing.xl),
        OutlinedButton.icon(
          onPressed: () => _confirmLogout(context),
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            foregroundColor: cs.error,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Log out',
      message: 'Are you sure you want to log out?',
      confirmLabel: 'Log out',
    );
    if (confirmed) await auth.logout();
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: theme.textTheme.bodySmall),
      subtitle: Text(
        value,
        style:
            theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Guest
// ---------------------------------------------------------------------------

class _GuestProfile extends StatelessWidget {
  const _GuestProfile();

  static const _benefits = [
    'Keep your bookings safe across sessions',
    'View upcoming and past bookings anytime',
    'Cancel and manage bookings easily',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        const SizedBox(height: AppSpacing.lg),
        const Center(child: AppLogo(size: 88)),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Create your free account',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          "You're browsing as a guest. Sign in to get the most out of "
          'QuickSlot.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xl),
        for (final benefit in _benefits) ...[
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: cs.primary, size: 20),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(benefit, style: theme.textTheme.bodyMedium)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: () => _push(context, const LoginPage()),
          child: const Text('Log in'),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: () => _push(context, const RegisterPage()),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Register'),
        ),
      ],
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

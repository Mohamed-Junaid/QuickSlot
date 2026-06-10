import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/venue_model.dart';
import '../../../data/repositories/venue_repository.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../venue_details/view/venue_details_page.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';
import '../widgets/venue_card_skeleton.dart';

/// Full list of active venues. [userId] is passed in because this route is
/// pushed above the auth provider.
class VenueListPage extends StatelessWidget {
  const VenueListPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VenueProvider(VenueRepository())..loadVenues(),
      child: _VenueListView(userId: userId),
    );
  }
}

class _VenueListView extends StatelessWidget {
  const _VenueListView({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venues')),
      body: Consumer<VenueProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case VenueViewState.initial:
            case VenueViewState.loading:
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: const [
                  VenueCardSkeleton(),
                  SizedBox(height: AppSpacing.lg),
                  VenueCardSkeleton(),
                  SizedBox(height: AppSpacing.lg),
                  VenueCardSkeleton(),
                ],
              );

            case VenueViewState.error:
              return AppErrorView(
                message: provider.errorMessage ?? 'Something went wrong.',
                onRetry: provider.loadVenues,
              );

            case VenueViewState.success:
              if (provider.isEmpty) {
                return const EmptyState(
                  icon: Icons.storefront_outlined,
                  title: 'No venues yet',
                  message: 'Venues will appear here once they are added.',
                );
              }
              return RefreshIndicator(
                onRefresh: provider.loadVenues,
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: provider.venues.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    final venue = provider.venues[index];
                    return VenueCard(
                      venue: venue,
                      onTap: () => _openDetails(context, venue),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  void _openDetails(BuildContext context, Venue venue) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            VenueDetailsPage(venue: venue, currentUserId: userId),
      ),
    );
  }
}

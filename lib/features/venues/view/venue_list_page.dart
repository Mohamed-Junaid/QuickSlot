import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/venue_model.dart';
import '../../../data/repositories/venue_repository.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../../venue_details/view/venue_details_page.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';

/// Lists all active venues. Owns its [VenueProvider] and renders one of the
/// loading / error / empty / success states.
class VenueListPage extends StatelessWidget {
  const VenueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VenueProvider(VenueRepository())..loadVenues(),
      child: const _VenueListView(),
    );
  }
}

class _VenueListView extends StatelessWidget {
  const _VenueListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venues')),
      body: Consumer<VenueProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case VenueViewState.initial:
            case VenueViewState.loading:
              return const AppLoader(message: 'Loading venues');

            case VenueViewState.error:
              return AppErrorView(
                message: provider.errorMessage ?? 'Something went wrong.',
                onRetry: provider.loadVenues,
              );

            case VenueViewState.success:
              if (provider.isEmpty) {
                return const EmptyState(
                  icon: Icons.storefront_outlined,
                  message: 'No venues available yet.',
                );
              }
              return RefreshIndicator(
                onRefresh: provider.loadVenues,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: provider.venues.length,
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
    final userId = context.read<AuthProvider>().userId;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VenueDetailsPage(venue: venue, currentUserId: userId),
      ),
    );
  }
}

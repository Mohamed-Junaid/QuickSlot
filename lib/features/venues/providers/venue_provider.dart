import 'package:flutter/foundation.dart';

import '../../../data/models/venue_model.dart';
import '../../../data/repositories/venue_repository.dart';

/// The four screen states the venue list can be in.
enum VenueViewState { initial, loading, success, error }

/// Holds and loads the venue list. The screen renders purely from this state.
class VenueProvider extends ChangeNotifier {
  VenueProvider(this._repository);

  final VenueRepository _repository;

  VenueViewState _state = VenueViewState.initial;
  List<Venue> _venues = const [];
  String? _errorMessage;

  VenueViewState get state => _state;
  List<Venue> get venues => _venues;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == VenueViewState.loading;
  bool get hasError => _state == VenueViewState.error;
  bool get isEmpty => _state == VenueViewState.success && _venues.isEmpty;
  bool get hasVenues => _state == VenueViewState.success && _venues.isNotEmpty;

  /// Loads venues from the repository, driving the state machine through
  /// loading then success or error.
  Future<void> loadVenues() async {
    _state = VenueViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _venues = await _repository.getVenues();
      _state = VenueViewState.success;
    } catch (_) {
      _venues = const [];
      _errorMessage = 'Could not load venues. Please try again.';
      _state = VenueViewState.error;
    }

    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/models/slot_model.dart';
import '../../../data/models/venue_model.dart';
import '../../../data/repositories/venue_repository.dart';

enum SlotViewState { initial, loading, success, error }

/// Holds the selected date and the slot grid for one venue. Changing the date
/// reloads the grid. No booking action yet — this only reads availability.
class SlotProvider extends ChangeNotifier {
  SlotProvider(this._repository, this._venue, [this._currentUserId])
      : _selectedDate = AppDateUtils.dayOnly(DateTime.now());

  final VenueRepository _repository;
  final Venue _venue;
  final String? _currentUserId;

  SlotViewState _state = SlotViewState.initial;
  DateTime _selectedDate;
  List<Slot> _slots = const [];
  String? _errorMessage;

  SlotViewState get state => _state;
  DateTime get selectedDate => _selectedDate;
  List<Slot> get slots => _slots;
  String? get errorMessage => _errorMessage;

  bool get isEmpty => _state == SlotViewState.success && _slots.isEmpty;

  /// Switches the selected day and reloads, unless that day is already shown.
  Future<void> selectDate(DateTime date) async {
    final day = AppDateUtils.dayOnly(date);
    final sameDay =
        AppDateUtils.dayKey(day) == AppDateUtils.dayKey(_selectedDate);
    if (sameDay && _state == SlotViewState.success) return;

    _selectedDate = day;
    await loadSlots();
  }

  /// Loads the slot grid for the currently selected date.
  Future<void> loadSlots() async {
    _state = SlotViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _slots = await _repository.getSlots(
        venue: _venue,
        date: _selectedDate,
        currentUserId: _currentUserId,
      );
      _state = SlotViewState.success;
    } catch (_) {
      _slots = const [];
      _errorMessage = 'Could not load slots. Please try again.';
      _state = SlotViewState.error;
    }

    notifyListeners();
  }
}

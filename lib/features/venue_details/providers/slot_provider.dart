import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/error/booking_exception.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/slot_model.dart';
import '../../../data/models/venue_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/venue_repository.dart';

enum SlotViewState { initial, loading, success, error }

/// Outcome of a book attempt, so the screen can show the right message.
enum BookSlotResult { success, slotTaken, notSignedIn, failure }

/// Time-of-day filter for the slot grid.
enum SlotTimeFilter { all, morning, afternoon, evening }

/// Holds the selected date and a live slot grid for one venue. Subscribes to a
/// Firestore stream so a slot flips to Booked across devices in realtime.
/// Changing the date re-subscribes; tapping a free slot books it transactionally.
class SlotProvider extends ChangeNotifier {
  SlotProvider(
    this._venueRepository,
    this._bookingRepository,
    this._venue, [
    this._currentUserId,
  ]) : _selectedDate = AppDateUtils.dayOnly(DateTime.now());

  final VenueRepository _venueRepository;
  final BookingRepository _bookingRepository;
  final Venue _venue;
  final String? _currentUserId;

  SlotViewState _state = SlotViewState.initial;
  DateTime _selectedDate;
  List<Slot> _slots = const [];
  String? _errorMessage;
  int? _bookingSlotIndex;
  SlotTimeFilter _filter = SlotTimeFilter.all;
  StreamSubscription<List<Slot>>? _subscription;

  SlotViewState get state => _state;
  DateTime get selectedDate => _selectedDate;
  List<Slot> get slots => _slots;
  String? get errorMessage => _errorMessage;
  SlotTimeFilter get filter => _filter;

  bool get isEmpty => _state == SlotViewState.success && _slots.isEmpty;

  /// The slot index currently being booked, so its tile can show a spinner.
  int? get bookingSlotIndex => _bookingSlotIndex;
  bool get isBooking => _bookingSlotIndex != null;

  /// Slots matching the active time-of-day filter.
  List<Slot> get visibleSlots {
    if (_filter == SlotTimeFilter.all) return _slots;
    return _slots.where((slot) => _matchesFilter(slot.startTime.hour)).toList();
  }

  bool _matchesFilter(int hour) {
    switch (_filter) {
      case SlotTimeFilter.all:
        return true;
      case SlotTimeFilter.morning:
        return hour < 12;
      case SlotTimeFilter.afternoon:
        return hour >= 12 && hour < 17;
      case SlotTimeFilter.evening:
        return hour >= 17;
    }
  }

  void setFilter(SlotTimeFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }

  /// Switches the selected day and re-subscribes, unless that day is shown.
  void selectDate(DateTime date) {
    final day = AppDateUtils.dayOnly(date);
    final sameDay =
        AppDateUtils.dayKey(day) == AppDateUtils.dayKey(_selectedDate);
    if (sameDay && _state == SlotViewState.success) return;

    _selectedDate = day;
    loadSlots();
  }

  /// (Re)subscribes to the live slot grid for the selected date. Named
  /// `loadSlots` so the error-retry button keeps working.
  void loadSlots() {
    _subscription?.cancel();
    _state = SlotViewState.loading;
    _errorMessage = null;
    notifyListeners();

    _subscription = _venueRepository
        .watchSlots(
          venue: _venue,
          date: _selectedDate,
          currentUserId: _currentUserId,
        )
        .listen(
      (slots) {
        _slots = slots;
        _state = SlotViewState.success;
        notifyListeners();
      },
      onError: (_) {
        _slots = const [];
        _errorMessage = 'Could not load slots. Please try again.';
        _state = SlotViewState.error;
        notifyListeners();
      },
    );
  }

  /// Books [slot] inside a Firestore transaction. The live stream reflects the
  /// result automatically, so no manual refresh is needed afterward.
  ///
  /// Returns [BookSlotResult.slotTaken] when another user won the race — the
  /// transaction in the repository threw [SlotUnavailableException].
  Future<BookSlotResult> bookSlot(Slot slot) async {
    final userId = _currentUserId;
    if (userId == null) return BookSlotResult.notSignedIn;
    if (_bookingSlotIndex != null) return BookSlotResult.failure;

    _bookingSlotIndex = slot.slotIndex;
    notifyListeners();

    BookSlotResult result;
    try {
      await _bookingRepository.bookSlot(
        venue: _venue,
        slot: slot,
        userId: userId,
      );
      result = BookSlotResult.success;
    } on SlotUnavailableException {
      result = BookSlotResult.slotTaken;
    } catch (_) {
      result = BookSlotResult.failure;
    }

    _bookingSlotIndex = null;
    notifyListeners();
    return result;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

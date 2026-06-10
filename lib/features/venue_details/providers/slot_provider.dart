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

/// Holds the selected date and the slot grid for one venue. Changing the date
/// reloads the grid; tapping a free slot books it transactionally.
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

  SlotViewState get state => _state;
  DateTime get selectedDate => _selectedDate;
  List<Slot> get slots => _slots;
  String? get errorMessage => _errorMessage;

  bool get isEmpty => _state == SlotViewState.success && _slots.isEmpty;

  /// The slot index currently being booked, so its tile can show a spinner.
  int? get bookingSlotIndex => _bookingSlotIndex;
  bool get isBooking => _bookingSlotIndex != null;

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
      _slots = await _venueRepository.getSlots(
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

  /// Books [slot] inside a Firestore transaction, then refreshes the grid so
  /// the result is reflected regardless of outcome.
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
    // Refresh availability after every attempt: on success the slot is now
    // taken, and on a lost race the grid catches up to reality.
    await loadSlots();

    return result;
  }
}

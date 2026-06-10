import 'package:flutter/foundation.dart';

import '../../../data/models/booking_model.dart';
import '../../../data/repositories/booking_repository.dart';

enum BookingsViewState { initial, loading, success, error }

/// Outcome of a cancel attempt, so the screen can show the right message.
enum CancelResult { success, failure }

/// Lists the signed-in user's bookings and cancels them. Cancelling reloads the
/// list and frees the underlying slot (its status flips to cancelled).
class BookingsProvider extends ChangeNotifier {
  BookingsProvider(this._repository, this._userId);

  final BookingRepository _repository;
  final String _userId;

  BookingsViewState _state = BookingsViewState.initial;
  List<Booking> _bookings = const [];
  String? _errorMessage;
  String? _cancellingBookingId;

  BookingsViewState get state => _state;
  List<Booking> get bookings => _bookings;
  String? get errorMessage => _errorMessage;

  bool get isEmpty =>
      _state == BookingsViewState.success && _bookings.isEmpty;

  /// The booking currently being cancelled, so its card can show a spinner.
  String? get cancellingBookingId => _cancellingBookingId;

  /// Loads the user's bookings, newest first.
  Future<void> loadBookings() async {
    _state = BookingsViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _repository.getUserBookings(_userId);
      _state = BookingsViewState.success;
    } catch (_) {
      _bookings = const [];
      _errorMessage = 'Could not load your bookings. Please try again.';
      _state = BookingsViewState.error;
    }

    notifyListeners();
  }

  /// Cancels [bookingId] transactionally, then reloads so the list and the
  /// freed slot reflect the change.
  Future<CancelResult> cancelBooking(String bookingId) async {
    if (_cancellingBookingId != null) return CancelResult.failure;

    _cancellingBookingId = bookingId;
    notifyListeners();

    CancelResult result;
    try {
      await _repository.cancelBooking(bookingId: bookingId, userId: _userId);
      result = CancelResult.success;
    } catch (_) {
      result = CancelResult.failure;
    }

    _cancellingBookingId = null;
    await loadBookings();

    return result;
  }
}

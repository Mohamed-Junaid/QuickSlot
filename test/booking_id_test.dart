import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/core/constants/firestore_collections.dart';
import 'package:quickslot/core/utils/num_converters.dart';

void main() {
  group('bookingDocId', () {
    test('builds the deterministic id that prevents double booking', () {
      final id = bookingDocId(
        venueId: 'venue_court_a',
        dayKey: '2026-06-10',
        slotIndex: 3,
      );
      expect(id, 'venue_court_a_2026-06-10_3');
    });

    test('same slot always maps to the same id (so a race collides)', () {
      final a = bookingDocId(
          venueId: 'v', dayKey: '2026-06-10', slotIndex: 0);
      final b = bookingDocId(
          venueId: 'v', dayKey: '2026-06-10', slotIndex: 0);
      expect(a, b);
    });
  });

  group('IntConverter', () {
    const converter = IntConverter();

    test('parses an int from Firestore', () {
      expect(converter.fromJson(8), 8);
    });

    test('parses a double from Firestore (console "double" entry)', () {
      expect(converter.fromJson(8.0), 8);
    });
  });
}

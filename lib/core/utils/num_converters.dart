import 'package:json_annotation/json_annotation.dart';

/// Parses an integer field that Firestore may return as either an `int` or a
/// `double` (e.g. a value entered as "double" in the console comes back as
/// `8.0`). A plain `as int` cast would throw on a double, so this normalizes
/// any numeric value to `int`.
class IntConverter implements JsonConverter<int, num> {
  const IntConverter();

  @override
  int fromJson(num value) => value.toInt();

  @override
  num toJson(int value) => value;
}

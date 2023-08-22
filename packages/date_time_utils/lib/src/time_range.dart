import 'package:comparators/comparators.dart';
import 'package:comparators/extensions.dart';
import 'package:flutter/material.dart';

import 'utils/time_of_day_utils.dart';

/// A class representing a range of time between the [from] (inclusive) and [to] (exclusive).
class TimeRange implements Comparable<TimeRange> {
  /// A starting time of this range, inclusive.
  final TimeOfDay from;

  /// An ending time of this range, inclusive.
  final TimeOfDay to;

  const TimeRange(this.from, this.to);

  factory TimeRange.normalize(TimeOfDay t1, TimeOfDay t2) {
    final compRes = t1.compareTo(t2);
    final res = switch (compRes) {
      > 0 => TimeRange(t2, t1),
      _ => TimeRange(t1, t2),
    };

    assert(res.from.toMinutes() <= res.to.toMinutes());

    return res;
  }

  @override
  String toString() => 'TimeRange{from: $from, to: $to}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeRange &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to;

  @override
  int get hashCode => from.hashCode ^ to.hashCode;

  @override
  int compareTo(TimeRange other) {
    return compare<TimeRange>((range) => range.from.toMinutes())
        .then(compare<TimeRange>((range) => range.to.toMinutes()))
        .call(this, other);
  }

  /// Whether the given [time] is before this [TimeRange].
  bool isAfter(TimeOfDay time) => from.isAfter(time);

  /// Whether the given [time] is after this [TimeRange].
  bool isBefore(TimeOfDay time) => to.isBefore(time);

  /// Whether the given time is contained in this [TimeRange] (is between [from] inclusive and [to]
  /// exclusive).
  bool contains(TimeOfDay time) => (from == time || from.isBefore(time)) && to.isAfter(time);

  /// Returns a copy of this [TimeRange] with the [from] and/or [to] overridden by the given values.
  /// If [normalize] if true (the default), the resulting TimeRange will be normalized by
  /// [TimeRange.normalize].
  TimeRange copyWith({TimeOfDay? from, TimeOfDay? to, bool normalize = true}) {
    final constructor = normalize ? TimeRange.normalize : TimeRange.new;

    return constructor(from ?? this.from, to ?? this.to);
  }
}

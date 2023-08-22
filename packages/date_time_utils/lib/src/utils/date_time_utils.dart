import 'package:flutter/material.dart' show TimeOfDay;

extension DateTimeUtils on DateTime {
  /// Returns a copy of this [DateTime] with the given [time] set.
  DateTime withTime(TimeOfDay time) => copyWith(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// Returns a copy of this [DateTime] with the given [time] set, assuring the returned DateTime is
  /// in the future compared to this DateTime.
  DateTime withTimeInFuture(TimeOfDay time) {
    final dt = withTime(time);

    if (dt.isAfter(this)) {
      return dt;
    }

    var res = add(const Duration(days: 1)).withTime(time);
    if (res.day == day) {
      res = res.add(const Duration(hours: 1));
    }

    return res;
  }

  /// Returns a copy of this [DateTime] with the time set to midnight.
  DateTime toDate() => copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// Returns a [TimeOfDay] with the [hour] and [minute] of this [DateTime].
  TimeOfDay toTime() => TimeOfDay(hour: hour, minute: minute);

  /// Returns a next date with the given [targetOrdinal], measuring from this date.
  /// If this date has the required ordinal, returns the result of the [toDate] method execution.
  DateTime nextDateWithOrdinal(int targetOrdinal) {
    const daylightSaveShiftDuration = Duration(hours: 1);

    final date = toDate();
    final ordinal = date.weekday - 1;

    var deltaDays = targetOrdinal - ordinal;
    if (deltaDays < 0) deltaDays += DateTime.daysPerWeek;

    var resDate = date.add(const Duration(days: 1) * deltaDays);

    // daylight shift compensation
    if (resDate.hour == 23) {
      resDate = resDate.add(daylightSaveShiftDuration);
    } else if (resDate.hour == 1) {
      resDate = resDate.subtract(daylightSaveShiftDuration);
    }

    assert((resDate.weekday - 1) == targetOrdinal);

    return resDate;
  }
}

DateTime minDate(DateTime a, DateTime b) {
  if (a == b || a.isBefore(b)) return a;
  return b;
}

DateTime maxDate(DateTime a, DateTime b) {
  if (a.isAfter(b)) return a;
  return b;
}

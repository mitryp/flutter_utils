import 'package:flutter/material.dart' show TimeOfDay;

extension TimeOfDayUtils on TimeOfDay {
  /// Converts this [TimeOfDay] to integer minutes.
  int toMinutes() => hour * TimeOfDay.minutesPerHour + minute;

  /// Compares this [TimeOfDay] to the [other].
  int compareTo(TimeOfDay other) => toMinutes().compareTo(other.toMinutes());

  /// Returns a copy of this [TimeOfDay] with the [duration] added. The smallest unit of time is a
  /// minute.
  TimeOfDay add(Duration duration) => timeFromMinutes(toMinutes() + duration.inMinutes);

  bool isBefore(TimeOfDay other) => compareTo(other) < 0;

  bool isAfter(TimeOfDay other) => compareTo(other) > 0;
}

/// Converts the given number of [minutes] to a [TimeOfDay].
TimeOfDay timeFromMinutes(int minutes) {
  const minutesPerHour = TimeOfDay.minutesPerHour;

  final hour = (minutes ~/ minutesPerHour);
  final minute = minutes - hour * minutesPerHour;

  return TimeOfDay(hour: hour, minute: minute);
}

/// Returns a smallest [TimeOfDay] among [t1] and [t2].
TimeOfDay minTime(TimeOfDay t1, TimeOfDay t2) {
  final comparisonRes = t1.compareTo(t2);

  return switch (comparisonRes) { <= 0 => t1, _ => t2 };
}

/// Returns the greatest [TimeOfDay] among [t1] and [t2].
TimeOfDay maxTime(TimeOfDay t1, TimeOfDay t2) {
  final comparisonRes = t1.compareTo(t2);

  return switch (comparisonRes) { > 0 => t1, _ => t2 };
}

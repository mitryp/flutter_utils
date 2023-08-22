import 'dart:math';

import 'package:date_time_utils/date_time_utils.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:test_utils/test_utils.dart';

import 'random_utils.dart';

const testRuns = 10000;

void main() {
  final random = Random();
  DateTime rDateTime() => DateTime.fromMillisecondsSinceEpoch(randomTimestamp(random));
  TimeOfDay rTime() => randomTime(random);

  group('`withTime` and `withTimeInFuture` tests', () {
    test(
      '`withTime` method works correctly',
      () => repeat(times: testRuns, () {
        final dt = rDateTime();
        final time = rTime();

        final dtWithTime = dt.withTime(time);

        expect(dtWithTime.day, equals(dt.day));
        expect(dtWithTime.month, equals(dt.month));
        expect(dtWithTime.year, equals(dt.year));

        final isDaylightSavingTime = dtWithTime.month == 3 || dtWithTime.month == 10;
        _expectHourEquality(dtWithTime.hour, time.hour, isDaylightSavingTime: isDaylightSavingTime);
        expect(dtWithTime.minute, equals(time.minute));

        expect(dtWithTime.second, equals(0));
        expect(dtWithTime.millisecond, equals(0));
        expect(dtWithTime.microsecond, equals(0));
      }),
    );

    test(
      '`withTimeInFuture` method works correctly',
      () => repeat(times: testRuns, () {
        final dt = rDateTime();
        final time = rTime();

        final dtWithTime = dt.withTimeInFuture(time);

        final isDaylightSavingTime = dt.month == 3 || dt.month == 10;
        _expectHourEquality(dtWithTime.hour, time.hour, isDaylightSavingTime: isDaylightSavingTime);
        expect(dtWithTime.minute, equals(time.minute));

        expect(dtWithTime.second, equals(0));
        expect(dtWithTime.millisecond, equals(0));
        expect(dtWithTime.microsecond, equals(0));

        // if (!dtWithTime.isAfter(dt)) {
        //   print('$dt with time $time: $dtWithTime');
        // }
        expect(dtWithTime.isAfter(dt), isTrue);
      }),
    );
  });

  test(
    '`toDate` method works correctly',
    () => repeat(times: testRuns, () {
      final dt = rDateTime();
      final date = dt.toDate();

      expect(date.day, equals(dt.day));
      expect(date.month, equals(dt.month));
      expect(date.year, equals(dt.year));

      expect(date.hour, equals(0));
      expect(date.minute, equals(0));
      expect(date.second, equals(0));
      expect(date.millisecond, equals(0));
      expect(date.microsecond, equals(0));
    }),
  );

  test(
    '`nextDateWithOrdinal` method works correctly',
    () => repeat(times: testRuns, () {
      final dt = rDateTime();
      final targetOrdinal = random.nextInt(DateTime.daysPerWeek);

      final next = dt.nextDateWithOrdinal(targetOrdinal);
      final resOrdinal = next.weekday - 1;

      expect(resOrdinal, equals(targetOrdinal));

      if (dt.weekday - 1 == targetOrdinal) {
        expect(next, equals(dt.toDate()));
      }
    }),
  );

  test(
    '`toTime` works correctly',
    () => repeat(times: testRuns, () {
      final dt = rDateTime();
      final time = dt.toTime();

      expect(time.hour, equals(dt.hour));
      expect(time.minute, equals(time.minute));
    }),
  );

  test(
    '`min and maxDate work correctly`',
    () => repeat(times: testRuns, () {
      final dt1 = rDateTime();
      final dt2 = rDateTime();

      final min = dt1.isBefore(dt2) || dt1 == dt2 ? dt1 : dt2;
      final max = dt1.isAfter(dt2) ? dt1 : dt2;

      expect(minDate(dt1, dt2), equals(min));
      expect(maxDate(dt1, dt2), equals(max));
    }),
  );
}

int _clampHour(int hour) => switch (hour) {
      < 0 => hour + TimeOfDay.hoursPerDay,
      >= 24 => hour - TimeOfDay.hoursPerDay,
      _ => hour,
    };

void _expectHourEquality(int actual, int matcher, {required bool isDaylightSavingTime}) {
  // taking the daylight saving time into account
  if (!isDaylightSavingTime || actual == matcher) {
    return expect(actual, equals(matcher));
  }

  final a = _clampHour(matcher - 1);
  final b = _clampHour(matcher + 1);
  final min = a <= b ? a : b;
  final max = b > a ? b : a;

  expect(actual, inInclusiveRange(min, max));
}

import 'dart:math' as math;

import 'package:date_time_utils/time_of_day_utils.dart';
import 'package:date_time_utils/time_range.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_utils/test_utils.dart';

import 'random_utils.dart';

const testRuns = 10000;

void main() {
  final random = math.Random();
  TimeOfDay rTime() => randomTime(random);
  TimeRange rRange() => TimeRange.normalize(rTime(), rTime());

  group('TimeRange tests', () {
    test(
      'TimeRange.normalize works correctly',
      () => repeat(times: testRuns, () {
        final t1 = rTime();
        final t2 = rTime();

        final range = TimeRange.normalize(t1, t2);

        expect(
          range.from.toMinutes(),
          lessThanOrEqualTo(range.to.toMinutes()),
          reason: 'The `from` TimeOfDay in a TimeRange must be less than or equal to the `to` time',
        );
      }),
    );

    test(
      'TimeRange comparison works correctly',
      () => repeat(times: testRuns, () {
        final r1 = rRange();
        final r2 = rRange();

        expect(r1.compareTo(r2), () {
          if (r1.from.isBefore(r2.from)) return -1;
          if (r2.from.isBefore(r1.from)) return 1;
          if (r1.to.isBefore(r2.to)) return -1;
          if (r2.to.isBefore(r1.to)) return 1;
          return 0;
        }());
      }),
    );

    test(
      'TimeRange to TimeOfDay comparison works correctly',
      () => repeat(times: testRuns, () {
        final range = rRange();
        final time = rTime();

        final status = _compareRangeToTime(range, time);

        if (status == -1) {
          // exclusive at the end
          expect(range.isBefore(time) || range.to == time, isTrue);
          expect(range.isAfter(time), isFalse);
          expect(range.contains(time), isFalse);
          return;
        }

        if (status == 0) {
          expect(range.contains(time), isTrue);
          expect(range.isBefore(time), isFalse);
          expect(range.isAfter(time), isFalse);
          return;
        }

        expect(range.isAfter(time), isTrue);
        expect(range.isBefore(time), isFalse);
        expect(range.contains(time), isFalse);
      }),
    );

    test(
      '`copyWith` works correctly',
      () => repeat(times: testRuns, () {
        final range = rRange();
        final t1 = rTime();
        final t2 = rTime();

        expect(range.copyWith(), range);
        expect(range.copyWith(from: t1, to: t2, normalize: false), equals(TimeRange(t1, t2)));
        expect(range.copyWith(from: t1, normalize: false), equals(TimeRange(t1, range.to)));
        expect(range.copyWith(to: t2, normalize: false), equals(TimeRange(range.from, t2)));
        expect(
          range.copyWith(to: t1, from: t2, normalize: true),
          equals(TimeRange.normalize(t1, t2)),
        );
      }),
    );
  });
}

/// -1 - [range] is before the [time]
///
///  0 - range contains the time
///
///  1 - range is after the time
int _compareRangeToTime(TimeRange range, TimeOfDay time) {
  final from = range.from;
  final to = range.to;
  // final timeMinutes = time.toMinutes();

  if (from.isAfter(time)) return 1;
  if (to.isBefore(time) || to == time) return -1;
  return 0;
  // if (fromMinutes > timeMinutes) return 1;
  // if (toMinutes <= timeMinutes) return -1;
  // return 0;
  // if (fromMinutes <= timeMinutes && toMinutes > timeMinutes) return 0;
  // if (toMinutes <= timeMinutes) return -1;
  // return 1;
}

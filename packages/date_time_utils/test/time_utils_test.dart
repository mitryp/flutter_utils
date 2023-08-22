import 'dart:math' as math;

import 'package:date_time_utils/time_of_day_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_utils/test_utils.dart';

import 'random_utils.dart';

const testRuns = 10000;

void main() {
  final random = math.Random();
  int rMinutes() => randomMinutes(random);
  TimeOfDay rTime() => randomTime(random);

  group('Time utils test', () {
    test(
      'TimeOfDay is converted to and from minutes correctly',
      () {
        return repeat(times: testRuns, () {
          final minutes = rMinutes();
          final timeOfDay = timeFromMinutes(minutes);

          expect(timeOfDay.hour, minutes ~/ 60);
          expect(timeOfDay.minute, minutes - 60 * (minutes ~/ 60));

          expect(
            timeOfDay.toMinutes(),
            minutes,
            reason: 'After a double conversion, minutes amount must remain the same',
          );
        });
      },
    );

    test(
      'TimeOfDay objects are compared correctly',
      () => repeat(times: testRuns, () {
        final minutes1 = rMinutes();
        final minutes2 = rMinutes();

        final time1 = timeFromMinutes(minutes1);
        final time2 = timeFromMinutes(minutes2);

        expect(
          time1.compareTo(time2),
          equals(() {
            if (minutes1 < minutes2) return -1;
            if (minutes2 < minutes1) return 1;
            return 0;
          }()),
        );
      }),
    );

    test(
      'Durations are added to TimeOfDay objects correctly',
      () => repeat(times: testRuns, () {
        final time = rTime();
        final minutesToAdd = rMinutes();

        expect(
          time.add(Duration(minutes: minutesToAdd)),
          timeFromMinutes(time.toMinutes() + minutesToAdd),
        );
      }),
    );

    test(
      'Time comparison functions work correctly',
      () => repeat(times: testRuns, () {
        final time1 = rTime();
        final time2 = rTime();

        final smallest = switch (time1.compareTo(time2)) { <= 0 => time1, _ => time2 };
        final greatest = switch (time1.compareTo(time2)) { > 0 => time1, _ => time2 };

        expect(minTime(time1, time2), equals(smallest));
        expect(maxTime(time1, time2), equals(greatest));
      }),
    );

    test(
      '`isBefore` and `isAfter` work correctly',
      () => repeat(times: testRuns, () {
        final t1 = rTime();
        final t2 = rTime();

        final t1Minutes = t1.toMinutes();
        final t2Minutes = t2.toMinutes();

        if (t1Minutes < t2Minutes) {
          expect(t1.isBefore(t2), isTrue);
          expect(t1.isAfter(t2), isFalse);
          return;
        }

        if (t1Minutes > t2Minutes) {
          expect(t1.isBefore(t2), isFalse);
          expect(t1.isAfter(t2), isTrue);
          return;
        }

        expect(t1.isAfter(t2), isFalse);
        expect(t1.isBefore(t2), isFalse);
        expect(t2.isAfter(t1), isFalse);
        expect(t2.isBefore(t1), isFalse);
      }),
    );
  });
}

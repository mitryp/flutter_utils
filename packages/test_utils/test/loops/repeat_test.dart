import 'dart:math';

import 'package:test/test.dart';
import 'package:test_utils/test_utils.dart';

import 'loop_tests_common.dart';

void main() {
  final random = Random();

  group('`repeat` test', () {
    test('`repeat` function repeats the function as many times, as expected', () {
      for (var run = 0; run < testRuns; run++) {
        _testRepeat(random);
      }
    });

    test(
      '`repeat` function throws a StateError when `times` == 0',
      () => expect(() => repeat(times: 0, () {}), throwsStateError),
    );
  });
}

void _testRepeat(Random random) =>
    testRepeatFunctionVariation(repeatFunction: repeat, random: random);

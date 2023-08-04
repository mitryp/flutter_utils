import 'dart:math';

import 'package:test/test.dart';
import 'package:test_utils/src/typedefs.dart';

const testRuns = 100;
const maxRepeatTimes = 1000;

typedef RepeatFunction = void Function(VoidCallback fn, {required int times});

/// Expects a [RepeatFunction] to repeat a certain amount of times, which is determined by [random].
void testRepeatFunctionVariation({
  required RepeatFunction repeatFunction,
  required Random random,
}) {
  final expectedTimes = random.nextInt(maxRepeatTimes);

  int repeatedTimes = 0;

  repeatFunction(times: expectedTimes, () => repeatedTimes++);

  expect(
    repeatedTimes,
    equals(expectedTimes),
    reason: 'repeatFunction should repeat the provided lambda '
        'exactly the specified amount of times',
  );
}

import 'dart:math';

import 'package:test/test.dart';
import 'package:test_utils/test_utils.dart';

import 'loop_tests_common.dart';

void main() {
  final random = Random();

  group('`repeatWithArgument` tests', () {
    test(
      '`repeatWithArgument` function repeats the function as many times, as expected',
      () {
        for (var run = 0; run < testRuns; run++) {
          _testRepeatWithArgumentRepetitions(random);
        }
      },
    );

    test('`repeatWithArgument` function throws a StateError when `times` == 0', () {
      expect(
        () => repeatWithArgument((_) {}, times: 0, argumentSupplier: (_) {}),
        throwsStateError,
      );
    });

    test('`repeatWithArgument` receives the correct argument from its `argumentSupplier`', () {
      int run = 0;

      repeatWithArgument(
        times: testRuns,
        argumentSupplier: _testArgumentSupplier,
        (arg) {
          expect(
            arg,
            equals(run++),
            reason: 'In this test, the received argument must be equal to the test run ordinal',
          );
        },
      );
    });
  });
}

void _testRepeatWithArgumentRepetitions(Random random) => testRepeatFunctionVariation(
      random: random,
      repeatFunction: (fn, {required times}) => repeatWithArgument(
        (_) => fn(),
        times: times,
        argumentSupplier: (_) {},
      ),
    );

int _testArgumentSupplier(int runOrdinal) => runOrdinal;

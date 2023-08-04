import 'typedefs.dart';

/// Repeats the function [fn] [times] times.
void repeat(VoidCallback fn, {required int times}) {
  _checkRepeatTimes(times);

  for (var i = 0; i < times; i++) {
    fn();
  }
}

/// Repeats the function [fn] with an argument supplied by the [argumentSupplier] [times] times.
void repeatWithArgument<T>(
  VoidTCallback<T> fn, {
  required int times,
  required ArgumentSupplier<T> argumentSupplier,
}) {
  _checkRepeatTimes(times);

  for (var run = 0; run < times; run++) {
    final argument = argumentSupplier(run);
    fn(argument);
  }
}

/// Throws a [StateError] if [times] is less than 1.
void _checkRepeatTimes(int times) =>
    times > 0 ? null : throw StateError('`times` must be greater than or equal to 1');

import 'typedefs.dart';

/// Repeats the function [fn] [times] times.
void repeat(VoidCallback fn, {required int times}) {
  assert(times > 0);

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
  assert(times > 0);

  for (var run = 0; run < times; run++) {
    final argument = argumentSupplier(run);
    fn(argument);
  }
}

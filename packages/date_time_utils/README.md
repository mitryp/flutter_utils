# date_time_utils

A bundle of utils related to `DateTime` and `TimeOfDay`, covered with unit tests.

## Featuring:

* `TimeRange` comparable class;
* `DateTime` and `TimeOfDay` comparison and min/max functions;
* `TimeOfDate` extension providing to/from minutes conversion, adding duration (with precision
  limited to minutes): `fromMinutes` function factory, `toMinutes` method, `add` method,
  `isBefore(time)` and `isAfter(time)` methods;
* `DateTime` extension for copying it with the given `TimeOfDay`: `withTime` and `withTimeInFuture`.
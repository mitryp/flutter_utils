/// A signature of a void function that takes no arguments.
typedef VoidCallback = void Function();

/// A signature of a void function that takes a single argument [arg] of type [T].
typedef VoidTCallback<T> = void Function(T arg);

/// A signature of a function that takes an integer [runOrdinal] and returns a value of type [T].
typedef ArgumentSupplier<T> = T Function(int runOrdinal);

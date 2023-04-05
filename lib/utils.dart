Iterable<U> filterMap<T, U>(Iterable<T> input, U? Function(T) fn) sync* {
  for (final entry in input) {
    final result = fn(entry);
    if (result != null) {
      yield result;
    }
  }
}

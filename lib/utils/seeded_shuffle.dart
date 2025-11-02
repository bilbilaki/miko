import 'dart:math';

/// Deterministically shuffles a copy of the list using [seed],
/// so results stay stable for the lifetime of that seed.
List<T> seededShuffle<T>(List<T> input, int seed) {
  final random = Random(seed);
  final list = List<T>.from(input);
  for (var i = list.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    final tmp = list[i];
    list[i] = list[j];
    list[j] = tmp;
  }
  return list;
}

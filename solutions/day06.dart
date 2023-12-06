import '../utils/index.dart';

typedef RecordWinner = (int, int);

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  (List<int>, List<int>) parseInput() {
    final lines = input.getPerLine();
    final numLines =
        lines.map((l) => l.split(RegExp(r'\D')).whereNot(isBlank)).toList();
    return (numLines[0].toIntList(), numLines[1].toIntList());
  }

  @override
  int solvePart1() {
    final inputRaw = parseInput();
    final input = inputRaw.$1.mapIndexed((idx, t) => (t, inputRaw.$2[idx]));
    return input.map((rw) {
      final (totalTime, recordDist) = rw;

      return List.generate(totalTime, (i) => distance(i, totalTime))
          .where((dist) => dist > recordDist)
          .length;
    }).reduce((v, e) => v * e);
  }

  // optimized to only calculate first and last winning time instead of all
  @override
  int solvePart2() {
    final (times, dists) = parseInput();
    final time = times.reduce(
      (value, element) => int.parse(value.toString() + element.toString()),
    );
    final recordDistance = dists.reduce(
      (value, element) => int.parse(value.toString() + element.toString()),
    );

    var firstHit = 0;
    for (var i = 1; i <= time; i++) {
      if (distance(i, time) > recordDistance) {
        firstHit = i;
        break;
      }
    }

    var lastHit = 0;
    for (var i = time; i >= firstHit; i--) {
      if (distance(i, time) > recordDistance) {
        lastHit = i;
        break;
      }
    }

    return lastHit - firstHit + 1;
  }

  int distance(int buttonHeld, int totalTime) {
    // speed = seconds held
    final boatSpeed = buttonHeld;
    final remainingTime = totalTime - buttonHeld;
    return boatSpeed * remainingTime;
  }
}

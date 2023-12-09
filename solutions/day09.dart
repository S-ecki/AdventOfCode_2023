import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  Iterable<List<int>> parseInput() {
    return input.getPerLine().map((l) => l.split(' ').toIntList());
  }

  @override
  int solvePart1() {
    return parseInput().map(extrapolate).sum;
  }

  @override
  int solvePart2() {
    return parseInput().map((l) => l.reversed).map(extrapolate).sum;
  }
}

int extrapolate(Iterable<int> line) {
  // full line of 0 is the base case
  if (line.every((n) => n == 0)) return 0;

  // we create a diff by calculating element 1 - 0, 2 - 1, ...
  // so I created a new list with all but the first element - this way,
  // we can zip the original list with the new one and get the diff at each
  // poisitin easily.
  final diff = zip([line.skip(1), line]).map((zipped) => zipped[0] - zipped[1]);

  return line.last + extrapolate(diff);
}

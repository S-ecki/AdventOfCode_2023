import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  Iterable<List<int>> parseInput() {
    return input.getPerLine().map((l) => l.split(' ').toIntList());
  }

  @override
  int solvePart1() {
    return parseInput().map(extrapolateIter).sum;
  }

  @override
  int solvePart2() {
    return parseInput().map((l) => l.reversed).map(extrapolateIter).sum;
  }
}

// My first solution to the problem. I like the cleanlyness and the fact that I
// managed to write a recursion 😅
// However, it's very inefficient, both solutions added take roughly 3 mins 🐌
// Thus, I wrote a second, less clean but much faster solution below.
int extrapolateRec(Iterable<int> line) {
  // full line of 0 is the base case
  if (line.every((n) => n == 0)) return 0;

  // we create a diff by calculating element 1 - 0, 2 - 1, ...
  // so I created a new list with all but the first element - this way,
  // we can zip the original list with the new one and get the diff at each
  // poisitin easily.
  final diff = zip([line.skip(1), line]).map((zipped) => zipped[0] - zipped[1]);

  return line.last + extrapolateRec(diff);
}

int extrapolateIter(Iterable<int> line) {
  var sum = 0;
  var list = line.toList();
  while (!list.every((element) => element == 0)) {
    sum += list.last;
    final diff = <int>[];
    for (var i = 1; i < list.length; i++) {
      final diffAt = list.elementAt(i) - list.elementAt(i - 1);
      diff.add(diffAt);
    }
    list = diff;
  }
  return sum;
}

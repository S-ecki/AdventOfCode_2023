import '../utils/index.dart';
import 'day03.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  late final galaxies = parseInput().where((char) => char == '#');
  late final emptyRows = emptyIndices(parseInput().asRows());
  late final emptyColumns = emptyIndices(parseInput().asColumns());

  @override
  Field<Char> parseInput() {
    return Field.fromString(input.asString);
  }

  @override
  int solvePart1() {
    return _solve(1);
  }

  @override
  int solvePart2() {
    return _solve(999999);
  }

  int _solve(int multiplier) {
    var sum = 0;
    for (var i = 0; i < galaxies.length - 1; i++) {
      for (var j = i + 1; j < galaxies.length; j++) {
        final pos1 = galaxies[i];
        final pos2 = galaxies[j];
        sum += expandedManhattan(
          pos1,
          pos2,
          multiplier,
        );
      }
    }

    return sum;
  }

  Iterable<int> emptyIndices(List<List<Char>> input) sync* {
    for (var i = 0; i < input.length; i++) {
      if (input[i].every((char) => char == '.')) yield i;
    }
  }

  int expandedManhattan(
    Position pos1,
    Position pos2, [
    int multiplier = 1,
  ]) =>
      manhattan(pos1, pos2) + (expandedBetween(pos1, pos2) * multiplier);

  int manhattan(Position pos1, Position pos2) {
    final (x1, y1) = pos1;
    final (x2, y2) = pos2;
    return (x1 - x2).abs() + (y1 - y2).abs();
  }

  int expandedBetween(
    Position pos1,
    Position pos2,
  ) {
    final (x1, y1) = pos1;
    final (x2, y2) = pos2;
    return emptyRows.where((row) => isBetween(row, y1, y2)).length +
        emptyColumns.where((col) => isBetween(col, x1, x2)).length;
  }

  bool isBetween(int n, int a, int b) {
    return (n >= a && n <= b) || (n >= b && n <= a);
  }
}

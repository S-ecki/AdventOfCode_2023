import '../utils/index.dart';

typedef GameLine = ({
  int id,
  List<int?> red,
  List<int?> green,
  List<int?> blue
});

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  Iterable<GameLine> parseInput() {
    final lines = input.getPerLine();
    return lines.mapIndexed((idx, l) {
      final sets = l.split(':')[1].split(';');
      final colorsPerSet = sets.map(
        (s) => (
          red: _numFromSet(s, 'red'),
          green: _numFromSet(s, 'green'),
          blue: _numFromSet(s, 'blue')
        ),
      );
      return (
        id: idx + 1,
        // it' a bummer that we cant destructure the record in the param list
        red: colorsPerSet.map((e) => e.red).toList(),
        green: colorsPerSet.map((e) => e.green).toList(),
        blue: colorsPerSet.map((e) => e.blue).toList()
      );
    });
  }

  @override
  int solvePart1() {
    return parseInput().where(_colorsBelowThreshold).map((game) => game.id).sum;
  }

  @override
  int solvePart2() {
    return parseInput()
        .map(
          (game) => (
            red: game.red.whereNotNull().max,
            green: game.green.whereNotNull().max,
            blue: game.blue.whereNotNull().max,
          ),
        )
        .map((colors) => colors.red * colors.green * colors.blue)
        .sum;
  }

  /// Returns 'null' if the color is not present in the set
  int? _numFromSet(String set, String color) {
    bool stringNotEmpty(String s) => s.isNotEmpty;
    if (!set.contains(color)) return null;

    return int.tryParse(
      set.split(color)[0].split(' ').where(stringNotEmpty).last,
    );
  }

  bool _colorsBelowThreshold(GameLine game) =>
      game.red.whereNotNull().every((r) => r <= 12) &&
      game.green.whereNotNull().every((g) => g <= 13) &&
      game.blue.whereNotNull().every((b) => b <= 14);
}

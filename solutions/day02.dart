import '../utils/index.dart';

typedef Game = ({int id, List<int?> red, List<int?> green, List<int?> blue});

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  Iterable<Game> parseInput() {
    final lines = input.getPerLine();
    return lines.mapIndexed((idx, l) {
      final colonSplit = l.split(':');
      final cubePart = colonSplit[1];
      final sets = cubePart.split(';');
      final colors = sets.map((s) {
        final redIndex = s.indexOf('red');

        final redMaybe = redIndex == -1
            ? null
            : int.tryParse(
                s.split('red')[0].split(' ').whereNot((e) => e.isEmpty).last,
              );
        final greenIndex = s.indexOf('green');
        final greenMaybe = greenIndex == -1
            ? null
            : int.tryParse(
                s.split('green')[0].split(' ').whereNot((e) => e.isEmpty).last,
              );
        final blueIndex = s.indexOf('blue');
        final blueMaybe = blueIndex == -1
            ? null
            : int.tryParse(
                s.split('blue')[0].split(' ').whereNot((e) => e.isEmpty).last,
              );
        return (redMaybe, greenMaybe, blueMaybe);
      });
      return (
        id: idx + 1,
        red: colors.map((e) => e.$1).toList(),
        green: colors.map((e) => e.$2).toList(),
        blue: colors.map((e) => e.$3).toList()
      );
    });
  }

  @override
  int solvePart1() {
    final validGames = parseInput().where(
      (game) =>
          game.red.whereNotNull().every((r) => r <= 12) &&
          game.green.whereNotNull().every((g) => g <= 13) &&
          game.blue.whereNotNull().every((b) => b <= 14),
    );
    return validGames.fold<int>(0, (sum, game) => sum + game.id);
  }

  @override
  int solvePart2() {
    final minSets = parseInput().map((game) {
      return (
        max(game.red.whereNotNull())!,
        max(game.green.whereNotNull())!,
        max(game.blue.whereNotNull())!
      );
    });
    final pows = minSets.map((e) => e.$1 * e.$2 * e.$3);

    return pows.sum;
  }
}

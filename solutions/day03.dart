import '../utils/index.dart';

/// There is no built-in `Char` type in Dart, so we use `String` instead and
/// typedef it to `Char` for better readability.
typedef Char = String;

// This solution is really ugly, as I tried to force my `Field` class onto
// the problem, which is not really suited for it. The `Field` class expects
// each individual cell to be semantically independent, which this problem
// has multi-digit numbers, which are not independent.
// Most of the code is just to get around this problem and ended up being an
// imperative mess.
// I dont have the willpower, nor the time to refactor this. 🙃
class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  Field<Char> parseInput() {
    final fieldInput = input.getPerLine().map((e) => e.split('')).toList();
    return Field(fieldInput);
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final relevantPos = _getRelevantDigitPositions(field)
        .removeNeighbourDigits(field)
        .removeDuplicates(field);
    return relevantPos.map((e) => _numberFromRelevantPosition(field, e)).sum;
  }

  @override
  int solvePart2() {
    final field = parseInput();

    final potentialGearPos = <Position>{};
    field.forEach((x, y) {
      if (field.getValueAt(x, y) == '*') {
        potentialGearPos.add((x, y));
      }
    });

    // key = gear position, value = (digit1, digit2)
    final gears = <Position, (Position, Position)>{};
    for (final (x, y) in potentialGearPos) {
      final digitNeighbours = field
          .neighbours(x, y)
          .where((pos) => field.getValueAtPosition(pos).isDigit)
          .removeNeighbourDigits(field)
          .toList();

      if (digitNeighbours.length == 2) {
        gears[(x, y)] = (digitNeighbours[0], digitNeighbours[1]);
      }
    }

    return gears.entries.map((entry) {
      final (pos1, pos2) = entry.value;
      final num1 = _numberFromRelevantPosition(field, pos1);
      final num2 = _numberFromRelevantPosition(field, pos2);
      return num1 * num2;
    }).sum;
  }

  /// Implements logic to reconstruct the number based on the position of a
  /// single digit.
  /// Is based on the fact that numbers are max 3 digits long.
  int _numberFromRelevantPosition(Field<Char> field, Position digitPos) {
    final (x, y) = digitPos;
    final row = field.getRow(y).join();
    final startSub = x - 2 < 0 ? 0 : x - 2;
    final endSub = x + 2 > row.length ? row.length : x + 2;
    final parts = row.substring(startSub, endSub + 1).split(RegExp(r'\D'))
      ..removeWhere(isBlank);

    final relevantNumberString = switch (parts.length) {
      1 => parts.first,
      2 => _determineRelevantNumFromTwoParts(parts, row[x]),
      3 => parts[1],
      _ => throw Exception('There should always be 1, 2 or 3 parts'),
    };
    return int.parse(relevantNumberString!);
  }

  String? _determineRelevantNumFromTwoParts(
    List<String> parts,
    Char middleChar,
  ) {
    if (parts.first.length != parts.last.length) {
      return max(parts, (a, b) => a.length.compareTo(b.length));
    }
    return middleChar;
  }

  Set<Position> _getRelevantDigitPositions(Field<Char> field) {
    final relevantDigitPositions = <Position>{};
    field.forEach((x, y) {
      if (field.getValueAt(x, y).isDigit) {
        final symbolNeighbours = field.neighbours(x, y).whereNot(
              (pos) =>
                  field.getValueAtPosition(pos) == '.' ||
                  field.getValueAtPosition(pos).isDigit,
            );
        if (symbolNeighbours.isNotEmpty) relevantDigitPositions.add((x, y));
      }
    });
    return relevantDigitPositions;
  }
}

extension on String {
  bool get isDigit => int.tryParse(this) != null;
}

extension on Iterable<Position> {
  Set<Position> removeNeighbourDigits(
    Field<Char> field,
  ) {
    final set = toSet();
    final toDelete = <Position>{};
    final respected = <Position>{};

    for (final (x, y) in set) {
      if (respected.contains((x, y))) continue;
      final relevantNeighbours =
          set.intersection(field.horizontalAdjacent(x, y).toSet());

      if (relevantNeighbours.isNotEmpty) {
        toDelete.add((x, y));
        // only one of the neighbours is added to avoid duplicates
        respected.add(relevantNeighbours.first);
      }
    }

    return set..removeAll(toDelete);
  }

  Set<Position> removeDuplicates(Field<Char> field) {
    final set = toSet();
    final duplicates = <Position>{};
    for (final (x, y) in set) {
      if (duplicates.contains((x, y))) {
        continue;
      }
      if (set.contains((x - 2, y)) &&
          field.getValueAtPosition((x - 1, y)).isDigit) {
        duplicates.add((x - 2, y));
      }
      if (set.contains((x + 2, y)) &&
          field.getValueAtPosition((x + 1, y)).isDigit) {
        duplicates.add((x + 2, y));
      }
    }
    return set..removeAll(duplicates);
  }
}

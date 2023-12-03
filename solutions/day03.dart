import '../utils/index.dart';

/// There is no built-in `Char` type in Dart, so we use `String` instead and
/// typedef it to `Char` for better readability.
typedef Char = String;

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
    final relevantDigitPosWithNeighbours = _getRelevantDigitPositions(field);
    final relevantPos = _removeNeighbourDigits(
      relevantDigitPosWithNeighbours,
      field,
    );

    final duplicates = <Position>{};
    for (final (x, y) in relevantPos) {
      if (duplicates.contains((x, y))) {
        continue;
      }
      if (relevantPos.contains((x - 2, y)) &&
          field.getValueAtPosition((x - 1, y)).isDigit) {
        duplicates.add((x - 2, y));
      }
      if (relevantPos.contains((x + 2, y)) &&
          field.getValueAtPosition((x + 1, y)).isDigit) {
        duplicates.add((x + 2, y));
      }
    }
    relevantPos.removeAll(duplicates);

    final relevantNumberStrings = <int>[];
    for (final pos in relevantPos) {
      relevantNumberStrings.add(_numberFromRelevantPosition(field, pos));
    }

    return relevantNumberStrings.sum;
  }

  int _numberFromRelevantPosition(Field<Char> field, Position pos) {
    final (x, y) = pos;
    final row = field.getRow(y).join();
    final startSub = x - 2 < 0 ? 0 : x - 2;
    final endSub = x + 2 > row.length ? row.length : x + 2;
    final ss = row.substring(startSub, endSub + 1);
    final parts = ss.split(RegExp(r'\D'))..removeWhere(isBlank);

    final relevantNumberString = switch (parts.length) {
      0 => throw Exception('No parts found'),
      1 => parts.first,
      2 => _determineRelevantNumOfTwoParts(parts, row[x]),
      3 => parts[1],
      _ => throw Exception('More than 3 parts found'),
    };
    return int.parse(relevantNumberString!);
  }

  String? _determineRelevantNumOfTwoParts(List<String> parts, Char middleChar) {
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
        if (symbolNeighbours.isNotEmpty) {
          relevantDigitPositions.add((x, y));
        }
      }
    });
    return relevantDigitPositions;
  }

  Set<Position> _removeNeighbourDigits(
    Set<Position> relevantDigitPositions,
    Field<Char> field,
  ) {
    final uniquieHorizontalNeighbours = <Position>{};
    final relevantCopy = {...relevantDigitPositions};

    for (final (x, y) in relevantCopy) {
      if (uniquieHorizontalNeighbours.contains((x, y))) {
        continue;
      }
      final relevantNeighbours =
          relevantCopy.intersection(field.horizontalAdjacent(x, y).toSet());

      uniquieHorizontalNeighbours.addAll(relevantNeighbours);
    }

    return relevantCopy..removeAll(uniquieHorizontalNeighbours);
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
      final digitNeighboursMaybe = field
          .neighbours(x, y)
          .where((pos) => field.getValueAtPosition(pos).isDigit)
          .toSet();

      final digitNeighbours =
          _removeIrrelevant(digitNeighboursMaybe, field).toList();

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

  Set<Position> _removeIrrelevant(
    Set<Position> relevantDigitPositions,
    Field<Char> field,
  ) {
    final toDelete = <Position>{};
    final respected = <Position>{};
    final relevantCopy = {...relevantDigitPositions};

    for (final (x, y) in relevantCopy) {
      ///todo delete
      if (respected.contains((x, y))) {
        continue;
      }
      final relevantNeighbours =
          relevantCopy.intersection(field.horizontalAdjacent(x, y).toSet());

      if (relevantNeighbours.isNotEmpty) {
        toDelete.add((x, y));
        // both left and right were added before, skipping over removing the second one
        respected.add(relevantNeighbours.first);
      }
    }

    return relevantCopy..removeAll(toDelete);
  }
}

extension on String {
  bool get isDigit => int.tryParse(this) != null;
}

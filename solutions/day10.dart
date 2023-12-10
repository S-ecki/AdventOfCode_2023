import '../utils/index.dart';
import 'index.dart';

typedef ConnectedPositions = Set<Position>;

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  (Field<ConnectedPositions>, Position) parseInput() {
    final rawField = Field.fromString(input.asString);
    // there is only one start position
    final startPosition = rawField.where((char) => char == 'S').first;
    final connectedPositionField =
        rawField.mapPositioned<ConnectedPositions>(getConnectedPositions);
    return (connectedPositionField, startPosition);
  }

  @override
  int solvePart1() {
    final (field, (startX, startY)) = parseInput();

    final posConnectedToStart = field.adjacent(startX, startY).where(
          (pos) => field.getValueAtPosition(pos).contains((startX, startY)),
        );

    var before = (startX, startY);
    var cur = posConnectedToStart.first;
    var counter = 0;
    while (cur != (startX, startY)) {
      final next = field
          .getValueAtPosition(cur)
          .whereNot((element) => element == before)
          .first;

      before = cur;
      cur = next;
      counter++;
    }

    return (counter / 2).ceil();
  }

  @override
  int solvePart2() {
    return 0;
  }

  Set<Position> getConnectedPositions(Position pos, Char pipe) {
    final (x, y) = pos;

    return switch (pipe) {
      '|' => {(x, y - 1), (x, y + 1)},
      '-' => {(x - 1, y), (x + 1, y)},
      'L' => {(x, y - 1), (x + 1, y)},
      'J' => {(x, y - 1), (x - 1, y)},
      '7' => {(x, y + 1), (x - 1, y)},
      'F' => {(x + 1, y), (x, y + 1)},
      '.' || 'S' => {},
      _ => throw StateError('Found a new pipe: $pipe')
    };
  }
}

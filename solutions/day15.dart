import '../utils/index.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  @override
  Iterable<String> parseInput() {
    return input.getBy(',');
  }

  @override
  int solvePart1() {
    return parseInput().map(_hash).sum;
  }

  @override
  int solvePart2() {
    final boxes = <int, List<LensInsertOperation>>{
      for (final i in range(256)) i.toInt(): [],
    };
    final operations = parseOperations();

    for (final op in operations) {
      final box = op.box;
      switch (op) {
        case LensInsertOperation():
          final lenses = boxes[box]!;
          final toReplace = lenses.where((lens) => lens.label == op.label);
          if (toReplace.isNotEmpty) {
            final idx = lenses.indexOf(toReplace.first);
            lenses
              ..removeWhere((lens) => lens.label == op.label)
              ..insert(idx, op);
          } else {
            lenses.add(op);
          }

        case LensRemoveOperation():
          boxes[box]!.removeWhere((lens) => lens.label == op.label);
      }
    }

    return boxes.entries
        .map(
          (box) => box.value.mapIndexed(
            (idx, lens) => focalPower(box.key, idx, lens.focalLength),
          ),
        )
        .flattened
        .sum;
  }

  List<LensOperation> parseOperations() {
    return parseInput().map((line) {
      if (line.contains('-')) {
        return LensRemoveOperation(line.replaceAll('-', ''));
      } else if (line.contains('=')) {
        final parts = line.split('=');
        return LensInsertOperation(parts[0], int.parse(parts[1]));
      } else {
        throw Exception('Invalid input: $line');
      }
    }).toList();
  }

  int focalPower(int box, int idx, int focalLength) {
    return (1 + box) * (1 + idx) * focalLength;
  }
}

int _hash(String word) => word.split('').fold(
      0,
      (cum, char) => ((cum + char.codeUnitAt(0)) * 17) % 256,
    );

sealed class LensOperation {
  LensOperation(this.label);

  final String label;
  int get box => _hash(label);
}

class LensRemoveOperation extends LensOperation {
  LensRemoveOperation(super.label);
}

class LensInsertOperation extends LensOperation {
  LensInsertOperation(super.label, this.focalLength);
  final int focalLength;
}

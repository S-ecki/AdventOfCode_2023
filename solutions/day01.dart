import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    return parseInput()
        .removeChars()
        .map(_extractBorderDigits)
        .map(int.parse)
        .sum;
  }

  @override
  int solvePart2() {
    return parseInput()
        .map(_stringToDigit)
        .removeChars()
        .map(_extractBorderDigits)
        .map(int.parse)
        .sum;
  }

  String _extractBorderDigits(String digitString) {
    final length = digitString.length;
    return switch (length) {
      0 => throw Exception('Empty line'),
      1 => digitString[0] * 2,
      _ => digitString[0] + digitString[length - 1],
    };
  }

  /// Unholy solution to replace the words with digits.
  ///
  /// Replacing the words with the digit directly would result in other words
  /// not being able to be replaced due to overlaping characters.
  /// E.g. 'eighthree' should be '83' but would be '8hree' if we would not apply
  /// the workaround below.
  String _stringToDigit(String named) {
    return named
        .replaceAll('one', 'o1e')
        .replaceAll('two', 't2o')
        .replaceAll('three', 't3e')
        .replaceAll('four', 'f4r')
        .replaceAll('five', 'f5e')
        .replaceAll('six', 's6x')
        .replaceAll('seven', 's7n')
        .replaceAll('eight', 'e8t')
        .replaceAll('nine', 'n9e')
        .replaceAll('zero', 'z0e');
  }
}

extension on Iterable<String> {
  /// Removes all non-digit characters from the strings in this list.
  Iterable<String> removeChars() => map((s) => s.replaceAll(RegExp(r'\D'), ''));
}

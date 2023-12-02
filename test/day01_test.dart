import 'package:test/test.dart';

import '../solutions/day01.dart';

const _exampleInput = '''
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet''';

const _exampleInput2 = '''
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen''';

const _exampleSolutionPart1 = 142;
const _exampleSolutionPart2 = 281;

const _puzzleSolutionPart1 = 54940;
const _puzzleSolutionPart2 = 54208;

void main() {
  group(
    'Day 01 - Example Input',
    () {
      test('Part 1', () {
        final day = Day01()..inputForTesting = _exampleInput;
        expect(day.solvePart1(), _exampleSolutionPart1);
      });
      test('Part 2', () {
        final day = Day01()..inputForTesting = _exampleInput2;
        expect(day.solvePart2(), _exampleSolutionPart2);
      });
    },
  );
  group(
    'Day 01 - Puzzle Input',
    () {
      final day = Day01();
      test('Part 1', () => expect(day.solvePart1(), _puzzleSolutionPart1));
      test('Part 2', () => expect(day.solvePart2(), _puzzleSolutionPart2));
    },
  );
}

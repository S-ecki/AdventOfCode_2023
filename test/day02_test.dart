import 'package:test/test.dart';

import '../solutions/day02.dart';

const _exampleInput = '''
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green''';

const _exampleSolutionPart1 = 8;
const _exampleSolutionPart2 = 2286;

const _puzzleSolutionPart1 = 2600;
const _puzzleSolutionPart2 = 86036;

void main() {
  group(
    'Day 02 - Example Input',
    () {
      final day = Day02()..inputForTesting = _exampleInput;
      test('Part 1', () => expect(day.solvePart1(), _exampleSolutionPart1));
      test('Part 2', () => expect(day.solvePart2(), _exampleSolutionPart2));
    },
  );
  group(
    'Day 02 - Puzzle Input',
    () {
      final day = Day02();
      test('Part 1', () => expect(day.solvePart1(), _puzzleSolutionPart1));
      test('Part 2', () => expect(day.solvePart2(), _puzzleSolutionPart2));
    },
  );
}

// ignore_for_file: unnecessary_null_comparison

import 'package:test/test.dart';

import '../solutions/day05.dart';

// *******************************************************************
// Fill out the variables below according to the puzzle description!
// The test code should usually not need to be changed, apart from uncommenting
// the puzzle tests for regression testing.
// *******************************************************************

/// Paste in the small example that is given for the FIRST PART of the puzzle.
/// It will be evaluated again the `_exampleSolutionPart1` below.
/// Make sure to respect the multiline string format to avoid additional
/// newlines at the end.
const _exampleInput1 = '''
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
// const _exampleInput2 = _exampleInput;
const _exampleInput2 = _exampleInput1;

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = 35;

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2 = 46;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = 642320287;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = null;

void main() {
  group(
    'Day 05 - Example Input',
    () {
      test('Part 1', () {
        final day = Day05()..inputForTesting = _exampleInput1;
        expect(day.solvePart1(), _exampleSolutionPart1);
      });
      test('Part 2', () {
        final day = Day05()..inputForTesting = _exampleInput2;
        expect(day.solvePart2(), _exampleSolutionPart2);
      });
    },
  );
  group(
    'Day 05 - Puzzle Input',
    () {
      final day = Day05();
      test(
        'Part 1',
        skip: _puzzleSolutionPart1 == null
            ? 'Skipped because _puzzleSolutionPart1 is null'
            : false,
        () => expect(day.solvePart1(), _puzzleSolutionPart1),
      );
      test(
        'Part 2',
        skip: _puzzleSolutionPart2 == null
            ? 'Skipped because _puzzleSolutionPart2 is null'
            : false,
        () => expect(day.solvePart2(), _puzzleSolutionPart2),
      );
    },
  );
}

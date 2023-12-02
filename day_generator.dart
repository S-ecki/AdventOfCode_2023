import 'dart:async';
import 'dart:io';

/// Small Program to be used to generate files and boilerplate for a given day.\
/// Call with `dart run day_generator.dart <day>`
void main(List<String?> args) async {
  const year = '2023';
  const session =
      // ignore: lines_longer_than_80_chars
      '53616c7465645f5f28e4263f5deab8edb6549781f9f7f512ff6c286535c0ca6936e6a059ea6aa0c92fe64e3b455835b544f85f7c8d3bc077f45da9fd845c2557';

  if (args.length > 1) {
    print('Please call with: <dayNumber>');
    return;
  }

  String? dayNumber;

  // input through terminal
  if (args.isEmpty) {
    print('Please enter a day for which to generate files');
    final input = stdin.readLineSync();
    if (input == null) {
      print('No input given, exiting');
      return;
    }
    // pad day number to have 2 digits
    dayNumber = int.parse(input).toString().padLeft(2, '0');
    // input from CLI call
  } else {
    dayNumber = int.parse(args[0]!).toString().padLeft(2, '0');
  }

  // inform user
  print('Creating day: $dayNumber');

  // Create lib file
  final dayFileName = 'day$dayNumber.dart';
  unawaited(
    File('solutions/$dayFileName').writeAsString(_dayTemplate(dayNumber)),
  );

  // Create test file
  final testFileName = 'day${dayNumber}_test.dart';
  unawaited(
    File('test/$testFileName').writeAsString(_testTemplate(dayNumber)),
  );

  final exportFile = File('solutions/index.dart');
  final exports = exportFile.readAsLinesSync();
  final content = "export 'day$dayNumber.dart';\n";
  var found = false;
  // check if line already exists
  for (final line in exports) {
    if (line.contains('day$dayNumber.dart')) {
      found = true;
      break;
    }
  }

  // export new day in index file if not present
  if (!found) {
    await exportFile.writeAsString(
      content,
      mode: FileMode.append,
    );
  }

  // Create input file
  print('Loading input from adventofcode.com...');
  try {
    final request = await HttpClient().getUrl(
      Uri.parse(
        'https://adventofcode.com/$year/day/${int.parse(dayNumber)}/input',
      ),
    );
    request.cookies.add(Cookie('session', session));
    final response = await request.close();
    final dataPath = 'input/aoc$dayNumber.txt';
    // unawaited(File(dataPath).create());
    await response.pipe(File(dataPath).openWrite());
  } catch (e) {
    print('Error loading file: $e');
  }

  print('All set, Good luck!');
}

String _dayTemplate(String dayNumber) {
  return '''
import '../utils/index.dart';

class Day$dayNumber extends GenericDay {
  Day$dayNumber() : super(${int.parse(dayNumber)});

  @override
  parseInput() {

  }

  @override
  int solvePart1() {

    return 0;
  }

  @override
  int solvePart2() {

    return 0;
  }
}

''';
}

String _testTemplate(String day) {
  return '''
import 'package:test/test.dart';

import '../solutions/day$day.dart';

// *******************************************************************
// Fill out the variables below according to the puzzle description!
// The test code should usually not need to be changed.
// *******************************************************************

/// Paste in the small example that is given for the FIRST PART of the puzzle.
/// It will be evaluated again the `_exampleSolutionPart1` below.
const _exampleInput1 = \'''
\''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
// const _exampleInput2 = _exampleInput;
const _exampleInput2 = \'''
\''';

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = 0;

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2 = 0;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
const _puzzleSolutionPart1 = 0;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
const _puzzleSolutionPart2 = 0;

void main() {
  group(
    'Day $day - Example Input',
    () {
      test('Part 1', () {
        final day = Day$day()..inputForTesting = _exampleInput1;
        expect(day.solvePart1(), _exampleSolutionPart1);
      });
      test('Part 2', () {
        final day = Day$day()..inputForTesting = _exampleInput2;
        expect(day.solvePart2(), _exampleSolutionPart2);
      });
    },
  );
  group(
    'Day $day - Puzzle Input',
    () {
      final day = Day$day();
      test('Part 1', () => expect(day.solvePart1(), _puzzleSolutionPart1));
      test('Part 2', () => expect(day.solvePart2(), _puzzleSolutionPart2));
    },
  );
}
''';
}

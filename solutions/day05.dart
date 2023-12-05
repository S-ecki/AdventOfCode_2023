import '../utils/index.dart';

typedef SeedsAndMappers = (List<int> seeds, List<Mapper> mappers);

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  SeedsAndMappers parseInput() {
    final parts = input.getBy('\n\n');
    final seeds = parts[0].split(': ')[1].split(' ').toIntList();
    final mappers = parts.skip(1).map((part) {
      final lines = part.split('\n').whereNot(isBlank);
      final instructions = lines.skip(1).map((line) {
        final instrParts = line.split(' ').toIntList();
        return MapInstruction(instrParts[0], instrParts[1], instrParts[2]);
      });
      return Mapper(instructions.toList());
    });
    return (seeds, mappers.toList());
  }

  @override
  int solvePart1() {
    final (seeds, mappers) = parseInput();
    final locations = seeds.map((seed) {
      for (final mapper in mappers) {
        seed = mapper.map(seed);
      }
      return seed;
    });

    return min(locations)!;
  }

  @override
  // I just used the very trivial solution from part 1 and brute forced it. This
  // is not ideal, as it takes a LOT of time. There would be smarter solutions,
  // like reversing the search (start by optimal location and go backwards), but
  // I dont have the time to implement that right now.
  //
  // Additionally, the superclass does not allow for async solutions. I found
  // the solutions by using different Isolates for each seedrange (essentially
  // doing the 9 ranges in parallel instead of after each other as I do here).
  // I did not commit this as it would require a lot of refactoring of the
  // whole template (I just printed the solution out instead of returning it
  // from the method as I do below).
  int solvePart2() {
    final (seedInstr, mappers) = parseInput();

    final seedRanges = <({int start, int length})>{};
    for (var i = 0; i < seedInstr.length; i = i + 2) {
      seedRanges.add((start: seedInstr[i], length: seedInstr[i + 1]));
    }

    // max int
    var locationMin = 0x7FFFFFFFFFFFFFFF;
    for (final seedRange in seedRanges) {
      final seedRangeEnd = seedRange.start + seedRange.length;
      // in and out, 5 minute adventure
      for (var i = seedRange.start; i < seedRangeEnd; i++) {
        var mappedSeed = i;
        for (final mapper in mappers) {
          mappedSeed = mapper.map(mappedSeed);
        }

        locationMin = min([mappedSeed, locationMin])!;
      }
    }

    return locationMin;
  }
}

class MapInstruction {
  MapInstruction(this.destination, this.source, this.rangeLength);

  factory MapInstruction.doNothing() => MapInstruction(0, 0, 0);

  final int destination;
  final int source;
  final int rangeLength;

  int mapWithInstruction(int value) => value + (destination - source);

  /// values are in the range of [source, source + rangeLength)
  bool belongsToInstruction(int value) {
    return value >= source && value < source + rangeLength;
  }
}

class Mapper {
  Mapper(this.instructions);

  final List<MapInstruction> instructions;

  int map(int value) {
    return instructions
        .firstWhere(
          (instr) => instr.belongsToInstruction(value),
          orElse: MapInstruction.doNothing,
        )
        .mapWithInstruction(value);
  }
}

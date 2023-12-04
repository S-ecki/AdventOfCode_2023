import 'dart:math';

import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  Iterable<ScratchCard> parseInput() {
    Iterable<int> parseNumbers(String numbers) =>
        numbers.split(' ').whereNot(isBlank).map(int.parse);

    return input.getPerLine().mapIndexed((idx, l) {
      final numbers = l.split(': ')[1].split('|');
      final winners = parseNumbers(numbers[0]).toSet();
      final owned = parseNumbers(numbers[1]).toSet();
      return ScratchCard(idx + 1, winners: winners, owned: owned);
    });
  }

  @override
  int solvePart1() {
    final board = parseInput();
    return board.map((card) => card.score).sum;
  }

  @override
  int solvePart2() {
    final board = parseInput();
    // key: id, value: numberOwned
    final brain = <int, int>{
      for (final card in board) card.id: 1,
    };

    for (final card in board) {
      final matches = card.quanitityMatched;
      // for each match, increments a card below w/ the amount of current cards
      for (var i = 1; i <= matches && i <= board.length; i++) {
        brain[card.id + i] = brain[card.id + i]! + brain[card.id]!;
      }
    }

    return brain.values.sum;
  }
}

class ScratchCard {
  ScratchCard(this.id, {required this.winners, required this.owned});

  final int id;
  final Set<int> winners;
  final Set<int> owned;

  int get quanitityMatched => winners.intersection(owned).length;
  int get score => pow(2, quanitityMatched - 1).floor();
}

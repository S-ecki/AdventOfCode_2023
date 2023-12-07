import '../utils/index.dart';
import 'index.dart';

typedef HandWithBid = (String hand, int bid);

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<HandWithBid> parseInput() {
    return input.getPerLine().map((l) {
      final parts = l.split(' ');
      return (parts[0], int.parse(parts[1]));
    }).toList();
  }

  @override
  int solvePart1() => _solve(withJoker: true);

  @override
  int solvePart2() => _solve(withJoker: true);

  int _solve({required bool withJoker}) {
    return parseInput()
        .sorted((lhs, rhs) {
          final (leftHand, _) = lhs;
          final (rightHand, _) = rhs;

          final leftType =
              withJoker ? getTypeWithJoker(leftHand) : getType(leftHand);
          final rightType =
              withJoker ? getTypeWithJoker(rightHand) : getType(rightHand);
          final typeCompare = leftType.index.compareTo(rightType.index);
          if (typeCompare != 0) return typeCompare;
          return compareStrength(leftHand, rightHand, withJoker: withJoker);
        })
        .reversed
        .map((e) => e.$2)
        .reduceIndexed((idx, prev, element) => prev + element * (idx + 1));
  }
}

Type getTypeWithJoker(String cards) {
  final numJoker = 'J'.allMatches(cards).length;
  if (numJoker == 0) return getType(cards);
  if (numJoker > 3) return Type.fiveOfAKind;
  cards = cards.replaceAll('J', '');

  if (_hasFourMatchesSomewhere(cards) != null) return Type.fiveOfAKind;
  if (_hasThreeMatchesSomewhere(cards) != null) {
    return numJoker == 1 ? Type.fourOfAKind : Type.fiveOfAKind;
  }
  if (getType(cards) == Type.twoPairs) return Type.fullHouse;
  if (getType(cards) == Type.onePair) {
    return switch (numJoker) {
      1 => Type.threeOfAKind,
      2 => Type.fourOfAKind,
      3 => Type.fiveOfAKind,
      _ => throw Exception('Invalid number of jokers: $numJoker'),
    };
  }

  return switch (numJoker) {
    1 => Type.onePair,
    2 => Type.threeOfAKind,
    3 => Type.fourOfAKind,
    4 || 5 => Type.fiveOfAKind,
    _ => throw Exception('Invalid number of jokers: $numJoker'),
  };
}

Type getType(String cards) {
  if (_hasNMatches(cards[0], cards, 5)) return Type.fiveOfAKind;
  if (_hasFourMatchesSomewhere(cards) != null) return Type.fourOfAKind;

  final threeMatchChar = _hasThreeMatchesSomewhere(cards);
  if (threeMatchChar != null) {
    final otherTwo = cards.replaceAll(threeMatchChar, '');
    if (_hasNMatches(otherTwo[0], cards, 2)) return Type.fullHouse;
    return Type.threeOfAKind;
  }

  final twoMatchChar = _hasTwoMatchesSomewhere(cards);
  if (twoMatchChar != null) {
    final otherThree = cards.replaceAll(twoMatchChar, '');

    // respecting case where jokers were removed
    if (otherThree.length >= 2 &&
        (_hasNMatches(otherThree[0], cards, 2) ||
            _hasNMatches(otherThree[1], cards, 2))) {
      return Type.twoPairs;
    }
    return Type.onePair;
  }

  return Type.highCard;
}

bool _hasNMatches(Char char, String s, int n) {
  assert(char.length == 1, 'Char must be a single character');
  return char.allMatches(s).length == n;
}

Char? _hasFourMatchesSomewhere(String s) {
  if (_hasNMatches(s[0], s, 4)) return s[0];
  if (_hasNMatches(s[1], s, 4)) return s[1];
  return null;
}

Char? _hasThreeMatchesSomewhere(String s) {
  final size = s.length;
  if (size > 0 && _hasNMatches(s[0], s, 3)) return s[0];
  if (size > 1 && _hasNMatches(s[1], s, 3)) return s[1];
  if (size > 2 && _hasNMatches(s[2], s, 3)) return s[2];
  return null;
}

Char? _hasTwoMatchesSomewhere(String s) {
  final size = s.length;
  if (size > 0 && _hasNMatches(s[0], s, 2)) return s[0];
  if (size > 1 && _hasNMatches(s[1], s, 2)) return s[1];
  if (size > 2 && _hasNMatches(s[2], s, 2)) return s[2];
  if (size > 3 && _hasNMatches(s[3], s, 2)) return s[3];
  return null;
}

final strengthList = 'AKQJT98765432'.split('').reversed.toList();
final strengthListWithJoker = 'AKQT98765432J'.split('').reversed.toList();

extension on Char {
  int get strength => strengthList.indexOf(this);
  int get strengthWithJoker => strengthListWithJoker.indexOf(this);
}

int compareStrength(String lhs, String rhs, {bool withJoker = false}) {
  for (var i = 0; i < lhs.length; i++) {
    if (lhs[i] == rhs[i]) continue;
    if (withJoker) {
      return rhs[i].strengthWithJoker.compareTo(lhs[i].strengthWithJoker);
    }
    return rhs[i].strength.compareTo(lhs[i].strength);
  }
  return 0;
}

enum Type {
  fiveOfAKind,
  fourOfAKind,
  fullHouse,
  threeOfAKind,
  twoPairs,
  onePair,
  highCard,
}

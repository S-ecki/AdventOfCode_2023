import 'package:test/test.dart';

import '../solutions/day02.dart';

void main() {
  test(
    'name',
    () async {
      expect(Day02().solvePart1(), 2600);
      expect(Day02().solvePart2(), 86036);
    },
  );
}

import 'package:quiver/iterables.dart';

import '../solutions/index.dart';

typedef Position = (int x, int y);
typedef VoidFieldCallback = void Function(int, int);

/// A helper class for easier work with 2D data.
class Field<T> {
  Field(List<List<T>> field)
      : assert(field.isNotEmpty, 'Field must not be empty'),
        assert(field[0].isNotEmpty, 'First position must not be empty'),
        // creates a deep copy by value from given field to prevent unwarranted
        // overrides
        _field = List<List<T>>.generate(
          field.length,
          (y) => List<T>.generate(field[0].length, (x) => field[y][x]),
        );

  /// Convenience method to create a Field from a single String, where the
  /// String is a "block" of characters.
  static Field<Char> fromString(String string) {
    final lines =
        string.split('\n').map((line) => line.trim().split('')).toList();
    return Field(lines);
  }

  final List<List<T>> _field;
  int get height => _field.length;
  int get width => _field[0].length;

  /// Returns the value at the given position.
  T getValueAtPosition(Position position) {
    final (x, y) = position;
    return _field[y][x];
  }

  /// Returns the value at the given coordinates.
  T getValueAt(int x, int y) => getValueAtPosition((x, y));

  /// Sets the value at the given Position.
  void setValueAtPosition(Position position, T value) {
    final (x, y) = position;
    _field[y][x] = value;
  }

  /// Sets the value at the given coordinates.
  void setValueAt(int x, int y, T value) => setValueAtPosition((x, y), value);

  /// Returns whether the given position is inside of this field.
  bool isOnField(Position position) {
    final (x, y) = position;
    return x >= 0 && y >= 0 && x < width && y < height;
  }

  /// Returns the whole row with given row index.
  List<T> getRow(int row) => _field[row];

  /// Returns the whole field as a list of rows.
  List<List<T>> asRows() => _field;

  /// Returns the whole column with given column index.
  List<T> getColumn(int column) => _field.map((row) => row[column]).toList();

  /// Returns the whole field as a list of columns.
  List<List<T>> asColumns() => List.generate(width, getColumn);

  /// Returns the minimum value in this field.
  T get minValue => min<T>(_field.expand((element) => element))!;

  /// Returns the maximum value in this field.
  T get maxValue => max<T>(_field.expand((element) => element))!;

  /// Executes the given callback for every position on this field.
  void forEach(VoidFieldCallback callback) {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        callback(x, y);
      }
    }
  }

  /// Returns the number of occurances of given object in this field.
  int count(T searched) => _field
      .expand((element) => element)
      .fold<int>(0, (acc, elem) => elem == searched ? acc + 1 : acc);

  List<Position> where(bool Function(T) test) {
    final result = <Position>{};
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final value = getValueAt(x, y);
        if (test(value)) result.add((x, y));
      }
    }
    return result.toList();
  }

  /// Executes the given callback for all given positions.
  void forPositions(
    Iterable<Position> positions,
    VoidFieldCallback callback,
  ) {
    for (final (x, y) in positions) {
      callback(x, y);
    }
  }

  /// Returns all adjacent cells to the given position. This does `NOT` include
  /// diagonal neighbours.
  Iterable<Position> adjacent(int x, int y) {
    return <Position>{
      (x, y - 1),
      (x, y + 1),
      (x - 1, y),
      (x + 1, y),
    }..removeWhere(
        (pos) {
          final (x, y) = pos;
          return x < 0 || y < 0 || x >= width || y >= height;
        },
      );
  }

  /// Returns all positional neighbours of a point. This includes the adjacent
  /// `AND` diagonal neighbours.
  Iterable<Position> neighbours(int x, int y) {
    return <Position>{
      // positions are added in a circle, starting at the top middle
      (x, y - 1),
      (x + 1, y - 1),
      (x + 1, y),
      (x + 1, y + 1),
      (x, y + 1),
      (x - 1, y + 1),
      (x - 1, y),
      (x - 1, y - 1),
    }..removeWhere(
        (pos) {
          final (x, y) = pos;
          return x < 0 || y < 0 || x >= width || y >= height;
        },
      );
  }

  /// Returns all horizontal neighbours of a position, aka left and right.
  Iterable<Position> horizontalAdjacent(int x, int y) {
    return <Position>{
      (x - 1, y),
      (x + 1, y),
    }..removeWhere(
        (pos) {
          final (x, y) = pos;
          return x < 0 || y < 0 || x >= width || y >= height;
        },
      );
  }

  /// Transforms each element in the field using a given function and returns a
  /// new `Field` with the transformed elements.
  Field<R> map<R>(R Function(T) transform) {
    final newField = List.generate(
      height,
      (y) => List.generate(width, (x) => transform(_field[y][x])),
    );
    return Field<R>(newField);
  }

  /// Transforms each element in the field using a given function and returns a
  /// new `Field` with the transformed elements.
  /// Also passes the position of the element to the transform function.
  Field<R> mapPositioned<R>(R Function(Position, T) transform) {
    final newField = List.generate(
      height,
      (y) => List.generate(width, (x) => transform((x, y), _field[y][x])),
    );
    return Field<R>(newField);
  }

  // Checks if any element in the field satisfies a given condition.
  bool any(bool Function(T) test) {
    for (final row in _field) {
      for (final value in row) {
        if (test(value)) return true;
      }
    }
    return false;
  }

  // Checks if every element in the field satisfies a given condition.
  bool every(bool Function(T) test) {
    for (final row in _field) {
      for (final value in row) {
        if (!test(value)) return false;
      }
    }
    return true;
  }

  /// Returns a deep copy by value of this [Field].
  Field<T> copy() {
    final newField = List<List<T>>.generate(
      height,
      (y) => List<T>.generate(width, (x) => _field[y][x]),
    );
    return Field<T>(newField);
  }

  @override
  String toString() {
    final result = StringBuffer();
    for (final row in _field) {
      for (final elem in row) {
        result.write(elem.toString());
      }
      result.write('\n');
    }
    return result.toString();
  }
}

/// Extension for [Field]s where `T` is of type [int].
extension IntegerField on Field<int> {
  /// Increments the values of Position `x` `y`.
  dynamic increment(int x, int y) => setValueAt(x, y, getValueAt(x, y) + 1);

  /// Convenience method to create a Field from a single String, where the
  /// String is a "block" of integers.
  static Field<int> fromString(String string) {
    final lines = string
        .split('\n')
        .map((line) => line.trim().split('').map(int.parse).toList())
        .toList();
    return Field(lines);
  }
}

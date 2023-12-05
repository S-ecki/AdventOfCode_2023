class ParseUtil {
  /// Throws an exception if any given String is not parseable.
  static List<int> stringListToIntList(Iterable<String> strings) {
    return strings.map(int.parse).toList();
  }

  /// Returns decimal number from binary string
  static int binaryToDecimal(String binary) {
    return int.parse(binary, radix: 2);
  }
}

extension StringListMapper on Iterable<String> {
  List<int> toIntList() => ParseUtil.stringListToIntList(this);
}

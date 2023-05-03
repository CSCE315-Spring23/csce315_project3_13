part of models_library;

/// Custom datatype representing a pair of objects
class pair
{
  dynamic left;
  dynamic right;

  /// Creates a new instance of [pair] with the given [left] and [right] objects
  pair(dynamic left, dynamic right) {
    this.left = left;
    this.right = right;
  }

  /// Creates a new instance of [pair] by parsing a string in the format "left, right"
  pair.fromString(String s) {
    this.left = s.split(', ')[0] as dynamic;
    this.right = s.split(', ')[1] as dynamic;
  }

  /// Returns a string representation of the [pair] in the format "left, right"
  String toString() {
    return "$left, $right";
  }

}
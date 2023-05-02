part of models_library;

class pair
{
  dynamic left;
  dynamic right;

  pair(dynamic left, dynamic right) {
    this.left = left;
    this.right = right;
  }

  pair.fromString(String s) {
    this.left = s.split(', ')[0] as dynamic;
    this.right = s.split(', ')[1] as dynamic;
  }

  String toString() {
    return "$left, $right";
  }

}
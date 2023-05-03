part of models_library;

/// Represents a row for the what sales together GUI report
class what_sales_together_row
{
  int id1 = 0;
  String item1 = "";
  int id2 = 0;
  String item2 = "";
  int num = 0;

  /// Constructs a row using the passed in parameters
  what_sales_together_row(int id1, String item1, int id2, String item2, int num) {
    this.id1 = id1;
    this.item1 = item1;
    this.id2 = id2;
    this.item2 = item2;
    this.num = num;
  }
}
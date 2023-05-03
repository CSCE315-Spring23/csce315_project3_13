import 'dart:collection';
import 'package:csce315_project3_13/Services/general_helper.dart';
import 'package:csce315_project3_13/Services/reports_helper.dart';
import '../Models/models_library.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// A class that provides methods to process and validate orders, and update inventory, transaction records, and reports.
class order_processing_helper
{
  general_helper gen_helper = general_helper();
  reports_helper report = reports_helper();

  /// Processes an order by checking the inventory levels, decrementing the inventory, and updating the transaction and sales records.
  ///
  /// This method takes an [order_obj] object as input, and returns a `Future<List<String>>` that represents a list of invalid item IDs. If the order is valid, the inventory will be decremented, a new transaction ID will be generated, and the transaction record and sales report will be updated accordingly. Otherwise, the list of invalid item IDs will be returned.
  Future<List<String>> process_order(order_obj order) async
  {
    Map<String, int> ingredient_amounts = await get_ingredient_totals(order.item_ids_in_order);
    List<String> invalid_items = await is_order_valid(ingredient_amounts);
    print("Checking if invalid...");
    if(invalid_items.isEmpty) {
      print("isEmpty!");
      for(MapEntry entry in ingredient_amounts.entries) {
        await inventory_decrement(entry.key, entry.value);
      }

      order.transaction_id = await get_new_transaction_id();
      await push_to_table(order.get_values());

      double tot = order.total_price;
      print('Updating x_rep with $tot');
      await report.update_x_report(order.total_price);
    }

    return invalid_items;
  }

  // Takes in an order_obj.item_ids_in_order, and will return a list of ints of item ids that do not have enough stock
  // If this list is empty, then the order is valid!
  /// Checks if an order is valid based on the inventory levels of each ingredient.
  ///
  /// This method takes a [Map<String, int>] object representing the total amount of each ingredient required for an order as input, and returns a `Future<List<String>>` that represents a list of invalid item IDs. If the inventory level for an ingredient is less than the required amount, its ID will be added to the list of invalid item IDs.
  Future<List<String>> is_order_valid(Map<String, int> ingredient_amounts) async
  {
    List<String> invalid_items = [];

    for(MapEntry entry in ingredient_amounts.entries) {
      int total = await gen_helper.get_total_amount_inv_stock(entry.key);
      await gen_helper.get_amount_inv_stock(entry.key);
      if(total < entry.value) {
        invalid_items.add(entry.key);
      }
    }

    return invalid_items;

  }


  // Returns false if the item requested does not have enough stock to decrement by
  /// Decrements the inventory level for an ingredient by the specified amount.
  ///
  /// This method takes a [String] representing the ID of the ingredient to be decremented and an [int] representing the amount by which to decrement it as input, and returns a `Future<void>`. If there is enough inventory for the ingredient, the inventory level will be decremented by the specified amount.
  Future<void> inventory_decrement(String ingredient, int amount_used) async
  {
    int amount_left_to_decrement = amount_used;
    HttpsCallable setter = FirebaseFunctions.instance.httpsCallable('updateInventoryRow');
    List<dynamic> inventory_item_amounts = await gen_helper.get_amount_inv_stock(ingredient);

    while(amount_left_to_decrement > 0) {
      if(inventory_item_amounts[0]['amount_inv_stock'] < amount_left_to_decrement) {
        await setter.call({
          'inv_order_id': inventory_item_amounts[0]['inv_order_id'],
          'new_amount' : 0
        });
        amount_left_to_decrement -= inventory_item_amounts[0]['amount_inv_stock'] as int;
        inventory_item_amounts.removeAt(0);
      } else {
        await setter.call({
          'inv_order_id': inventory_item_amounts[0]['inv_order_id'],
          'new_amount' : ((inventory_item_amounts[0]['amount_inv_stock'] as int) - amount_left_to_decrement)
        });
        amount_left_to_decrement = 0;
      }
    }

  }


  /// Retrieves the total amount of ingredients required for a given list of items in an order.
  ///
  /// The function takes a [List] of [int]s representing the item IDs in the order as input.
  /// It returns a [Future] that resolves to a [Map] of [String] keys and [int] values, representing the ingredient names and their total amounts required for the order, respectively.
  Future<Map<String, int>> get_ingredient_totals(List<int> items) async
  {
    Map<String, int> ingredient_amounts = HashMap();

    for(int item_id in items) {
      String item_name = await gen_helper.get_item_name(item_id);
      String item_type = await gen_helper.get_item_type(item_id);
      if (item_type == "smoothie") {
        HttpsCallable get_ingredients = FirebaseFunctions.instance.httpsCallable('getMenuItemIngredients');
        final ingredients = await get_ingredients.call({'menu_item_name': item_name});
        List<dynamic> data = ingredients.data;
        for (int i = 0; i < data.length; i++) {
          String ing_name = data[i]['ingredient_name'];
          int amount = data[i]['ingredient_amount'];
          ingredient_amounts.update(ing_name, (value) => value + amount, ifAbsent: () => amount);
        }
      }
      else {
        ingredient_amounts.update(item_name, (value) => ++value, ifAbsent: () => 1);
      }
    }

    return ingredient_amounts;

  }

  /// Adds an order to the order history table.
  ///
  /// The function takes a [String] representing the order values to be added to the table as input.
  Future<void> push_to_table(String values) async
  {
    HttpsCallable adder = FirebaseFunctions.instance.httpsCallable('insertIntoOrderHistory');
    await adder.call({'values': values});
  }

  /// This function is an asynchronous operation and returns a [Future] that resolves to an [int] representing the new transaction ID.
  ///
  /// The function makes a Firebase Functions call to retrieve the maximum transaction ID from the database, increments it by 1, and returns the new ID.
  Future<int> get_new_transaction_id() async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('newTransID');
    final item_name_query = await getter.call();
    List<dynamic> data = item_name_query.data;
    int new_id = data[0]['max'];

    return (new_id + 1);
  }
}
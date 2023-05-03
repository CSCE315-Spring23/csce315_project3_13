import 'dart:collection';
import '../Models/models_library.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intl/intl.dart';

/// A collection of helper functions for accessing data from Firebase and performing general tasks.
class general_helper
{
  /// Retrieves the name of a menu item given its ID.
  ///
  /// Returns the name of the menu item as a String.
  Future<String> get_item_name(int menu_item_id) async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getMenuItemName');
    final item_name_query = await getter.call({'menu_item_id': menu_item_id});
    List<dynamic> data = item_name_query.data;
    String menu_item = data[0]['menu_item'];

    return menu_item;
  }

  /// Retrieves the type of a menu item given its ID.
  ///
  /// Returns the type of the menu item as a String.
  Future<String> get_item_type(int menu_item_id) async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getMenuItemType');
    final item_name_type = await getter.call({'menu_item_id': menu_item_id});
    List<dynamic> data = item_name_type.data;
    String type = data[0]['type'];

    return type;
  }

  /// Retrieves the ingredients and amounts for a smoothie menu item given its ID.
  ///
  /// Returns a Map where the keys are the ingredient names (as Strings) and the values are the amounts (as ints).
  Future<Map<String, int>> get_smoothie_ingredients(int menu_item_id) async
  {
    Map<String, int> ingredients = HashMap();
    HttpsCallable get_ingredients = FirebaseFunctions.instance.httpsCallable('getMenuItemIngredients');
    String item_name = await get_item_name(menu_item_id);
    final query = await get_ingredients.call({'menu_item_name': item_name});
    List<dynamic> data = query.data;
    for (int i = 0; i < data.length; i++) {
      String ing_name = data[i]['ingredient_name'];
      int amount = data[i]['ingredient_amount'];
      ingredients[ing_name] = amount;
    }
    return ingredients;
  }

  /// Retrieves the total amount of an ingredient currently in inventory.
  ///
  /// [ingredient] - The name of the ingredient to retrieve the amount of.
  ///
  /// Returns the total amount of the ingredient as an int.
  Future<int> get_total_amount_inv_stock(String ingredient) async
  {
    List<dynamic> data = await get_amount_inv_stock(ingredient);
    int total = 0;
    for(int i = 0; i < data.length; ++i) {
      total += data[i]['amount_inv_stock'] as int;
    }
    return total;
  }

  /// Retrieves the amount of an ingredient currently in inventory for each location.
  ///
  /// [ingredient] - The name of the ingredient to retrieve the amounts of.
  ///
  /// Returns a List of Maps where each Map contains the inventory amount (as an int) for a single location.
  Future<List<dynamic>> get_amount_inv_stock(String ingredient) async
  {
    HttpsCallable get_amt_in_stock = FirebaseFunctions.instance.httpsCallable('getAmountInvStock');
    dynamic res = await get_amt_in_stock.call({'ingredient': ingredient});
    return res.data;
  }

  /// Retrieves the row ID for a specific ingredient in a menu item.
  ///
  /// [menu_item_name] - The name of the menu item that contains the ingredient.
  ///
  /// [ingredient_name] - The name of the ingredient to retrieve the row ID for.
  ///
  /// Returns the row ID of the ingredient as an int.
  Future<int> get_ingredient_row_id(String menu_item_name, String ingredient_name) async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getIngredientRowId');
    final res = await getter.call({
      'menu_item_name': menu_item_name,
      'ingredient_name': ingredient_name
    });
    return (res.data[0]['row_id'] as int);
  }

  /// Retrieves the current date as a formatted string.
  ///
  /// Returns the current date as a formatted String in the format 'MM/dd/yyyy'.
  Future<String> get_current_date() async
  {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM/dd/yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }


  /// Retrieves information for all menu items.
  ///
  /// Returns a Map where the keys are the menu item IDs (as ints) and the values are Lists containing the name (as a String), type (as a String), and price (as a double) of each menu item.
  Future<Map<int, List<dynamic>>> get_all_menu_item_info() async{
    Map<int, List<dynamic>> item_info = {};
    HttpsCallable get_item_info = FirebaseFunctions.instance.httpsCallable('getMenuItemsInfo');
    final info_res = await get_item_info();
    List<dynamic> item_data = info_res.data;
    for(dynamic d in item_data) {
      int id = d['menu_item_id'];
      if(id < 1000) {
        String name = d['menu_item'];
        String type = d['type'];
        String money = d['item_price'];
        double price = double.parse(money.substring(1, money.length));
        item_info[id] = [name, type, price];
      }
    }
    return item_info;
  }

}
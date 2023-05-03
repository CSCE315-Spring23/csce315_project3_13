import 'package:cloud_functions/cloud_functions.dart';

/// A helper class for retrieving data related to menu items, such as names, prices, and IDs.
class view_helper {
  /// Retrieves a list of all smoothie names from the Firebase Cloud Functions.
  /// Returns a Future containing a List of Strings.
  Future<List<String>> get_all_smoothie_names() async {

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getSmoothieNames');
    final smoothie_name_query = await callable();
    List result = smoothie_name_query.data;
    List<String> names = [];

    for (int i = 0; i < result.length; i++) {
      names.add(result[i]['menu_item']);
    }

    print(names);

    return names;
  }

  /// Retrieves the price of a specified menu item from the Firebase Cloud Functions.
  /// Takes a String argument of the menu item's name.
  /// Returns a Future containing a double value representing the item's price.
  Future<double> get_item_price(String item_name) async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getItemPrice');
    final item_name_query = await getter.call({'menu_item_name': item_name});
    List<dynamic> data = item_name_query.data;
    String item_price_str = data[0]['item_price'];
    double item_price = double.parse(item_price_str.replaceAll('\$', ''));

    return item_price;
  }

  /// Retrieves the ID of a specified menu item from the Firebase Cloud Functions.
  /// Takes a String argument of the menu item's name.
  /// Returns a Future containing an integer value representing the item's ID.
  Future<int> get_item_id(String item_name) async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getItemID');
    final item_name_query = await getter.call({'menu_item_name': item_name});
    List<dynamic> data = item_name_query.data;
    int item_id = data[0]['menu_item_id'];

    return item_id;
  }

  /// Retrieves a list of unique smoothie names from the Firebase Cloud Functions.
  /// Returns a Future containing a List of Strings.
  Future<List<String>> get_unique_smoothie_names() async {

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getSmoothieNames');
    final smoothie_name_query = await callable();
    List result = smoothie_name_query.data;
    List<String> names = [];
    String clipped_name = "";
    int unclipped_length = 0;

    for (int i = 0; i < result.length; i++) {
      if (result[i]['menu_item'].contains("small")) {
        unclipped_length = result[i]['menu_item'].length;
        clipped_name = result[i]['menu_item'].substring(0, unclipped_length - 6);
        names.add(clipped_name);
      }
    }

    return names;
  }

  /// Retrieves a list of addon names from Firebase Functions.
  ///
  /// Returns a [Future] that completes with a [List] of [String] values representing the addon names.
  Future<List<String>> get_addon_names() async {

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getAddonNames');
    final addon_name_query = await callable();
    List result = addon_name_query.data;
    List<String> names = [];

    for (int i = 0; i < result.length; i++) {
      names.add(result[i]['menu_item']);
    }

    print(names);

    return names;
  }

  /// Retrieves a list of snack names from Firebase Functions.
  ///
  /// Returns a [Future] that completes with a [List] of [String] values representing
  /// the snack names.
  Future<List<String>> get_snack_names() async {

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getSnackNames');
    final snack_name_query = await callable();
    List result = snack_name_query.data;
    List<String> names = [];

    for (int i = 0; i < result.length; i++) {
      names.add(result[i]['menu_item']);
    }

    print(names);

    return names;
  }
}
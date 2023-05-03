import 'package:cloud_functions/cloud_functions.dart';

import '../Models/models_library.dart';


/// This class provides helper functions to interact with the inventory table in the Firebase database.
class inventory_item_helper
{
  /// Retrieves a map of inventory items with their respective amounts in stock.
  /// Returns a Future<Map<String, num>> representing the inventory items and their amounts.
  Future<Map<String, num>> get_inventory_items() async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getInventoryItems');
    final result = await callable.call();

    Map<String, num> inventoryItems = {};
    for (var itemData in result.data)
    {
      if (itemData["status"] == "unavailable")
      {
        continue;
      }
      String itemName = itemData["ingredient"];
      if (!inventoryItems.containsKey(itemName))
      {
        inventoryItems[itemName] = 0;
      }
      inventoryItems[itemName] = (inventoryItems[itemName] ?? 0) + (itemData["amount_inv_stock"] ?? 0);

    }
    // for (String itemName in inventoryItems.keys) {
    //   num? amount = inventoryItems[itemName];
    //   print("$itemName: $amount");
    // }

    return inventoryItems;
  }

  /// Adds a new row to the inventory table in the Firebase database.
  /// [item] is an [inventory_item_obj] object that contains the values to be added to the table.
  /// Returns a Future<int> representing the ID of the newly added row.
  Future<int> add_inventory_row(inventory_item_obj item) async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('addInventoryRow');
    final result = await callable.call({'values': item.toJson()});

    return result.data;
  }

  /// Deletes a row from the inventory table in the Firebase database.
  /// [itemName] is a String representing the name of the item to be deleted.
  Future<void> deleteInventoryItem(String itemName) async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('deleteInventoryItem');
    final result = await callable.call({'itemName': itemName});
  }

  /// Edits the amount of an existing row in the inventory table in the Firebase database.
  /// [itemName] is a String representing the name of the item to be edited.
  /// [changeAmount] is a num representing the amount to be added to the existing amount.
  /// Returns a Future<bool> representing the success of the operation.
  Future<bool> edit_inventory_entry(String itemName, num changeAmount) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('editInventoryEntry');
    final result = await callable.call({'itemName': itemName, 'changeAmount': changeAmount});

    return result.data;
  }



}

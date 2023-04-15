import 'package:cloud_functions/cloud_functions.dart';

import '../Models/models_library.dart';

class inventory_item_helper
{
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
    for (String itemName in inventoryItems.keys) {
      num? amount = inventoryItems[itemName];
      print("$itemName: $amount");
    }

    return inventoryItems;
  }


  Future<int> add_inventory_row(inventory_item_obj item) async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('addInventoryRow');
    final result = await callable.call({'values': item.toJson()});

    return result.data;
  }

  Future<void> deleteInventoryItem(String itemName) async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('deleteInventoryItem');
    final result = await callable.call({'itemName': itemName});
  }


}

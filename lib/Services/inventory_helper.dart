import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:csce315_project3_13/Services/reports_helper.dart';

import '../Models/models_library.dart';

class inventory_item_helper
{
  //reports_helper report = reports_helper();

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

  Future<bool> edit_inventory_entry(String itemName, num changeAmount) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('editInventoryEntry');
    final result = await callable.call({'itemName': itemName, 'changeAmount': changeAmount});

    return result.data;
  }

  Future<Map<String, int>> place_order(String itemName) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getIngredientOrder');
    final result = await callable.call({'itemName': itemName});
    Map<String, int> map = HashMap();
    for(var i in result.data){
    map[i["unit"]] = i["conversion"];
    }
    //print(map);
    return map;
  }

  Future<Map<String, num>> get_order_items() async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getOrderItems');
    final result = await callable.call();

    Map<String, num> inventoryItems = {};
    for (var itemData in result.data)
    {
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

  Future<Map<String, String>> getExpire() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getExpiration');
    final result = await callable.call();
    Map<String, String> map = HashMap();
    for (var i in result.data) {
      int years = i['interval']['years'] ?? 0;
      int days = i['interval']['days'] ?? 0;

      // Compute the new expiration date
      DateTime now = DateTime.now();
      DateTime expirationDate = DateTime(now.year + years, now.month, now.day + days);

      // Format the expiration date as a string
      String formattedExpirationDate = "${expirationDate.month}/${expirationDate.day}/${expirationDate.year}";

      map[i['ingredient']] = formattedExpirationDate;
    }

   // print(map);
    return map;
  }

  // Future<void> restock() async {
  //   Map<String, String> expire = await getExpire();
  //   Map<dynamic, int> restock_report = await report.generate_restock_report();
  //   Map<String, int> conv;
  //
  //   for (var entry in restock_report.keys.first) {
  //     conv = await place_order(entry);
  //     // Get the conversion map for the ingredient
  //     String ingredient = entry.key;
  //     int amount_inv_stock = entry.value;
  //     int conversion = conv['conversion']!;
  //     String unit = conv['unit']!.toString();
  //     String expiration_date = expire[ingredient]!;
  //     int amount_ordered = (amount_inv_stock / conversion).ceil();
  //     String date_ordered = DateTime.now().toString();
  //
  //     inventory_item_obj item = inventory_item_obj(
  //       0, // inv_order_id
  //       "available", // status
  //       ingredient,
  //       amount_inv_stock,
  //       amount_ordered,
  //       unit,
  //       date_ordered,
  //       expiration_date,
  //       conversion,
  //     );
  //
  //     item.toJson();
  //     // Add new inventory item object to the database
  //   //  await DatabaseHelper.instance.insertInventory(item);
  //   }
  //
  //
  // }


}

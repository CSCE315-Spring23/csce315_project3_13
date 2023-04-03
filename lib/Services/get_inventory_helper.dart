import '../Models/inventory_item_obj.dart';
import 'package:cloud_functions/cloud_functions.dart';

class inventory_item_helper
{
  Future<List<inventory_item_obj>> get_inventory_items() async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getInventoryItems');
    final result = await callable.call();

    List<dynamic> inventoryData = List.from(result.data);
    List<inventory_item_obj> inventoryItems = [];
    for (var itemData in inventoryData) {
      inventory_item_obj item = inventory_item_obj(
          itemData["inv_order_id"],
          itemData["inv_item_id"],
          itemData["ingredient"],
          itemData["amount_inv_stock"],
          itemData["amount_ordered"],
          itemData["unit"],
          itemData["date_ordered"],
          itemData["expiration_date"],
          itemData["conversion"]
      );
      inventoryItems.add(item);
    }

    return inventoryItems;
  }

  Future<int> add_inventory_row(inventory_item_obj item) async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('addInventoryRow');
    final result = await callable.call({'values': item.toJson()});

    return result.data;
  }
}

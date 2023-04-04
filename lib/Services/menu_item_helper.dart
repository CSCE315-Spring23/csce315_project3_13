import 'package:csce315_project3_13/Services/general_helper.dart';
import 'package:csce315_project3_13/Services/ingredients_table_helper.dart';
import '../Models/models_library.dart';
import 'package:cloud_functions/cloud_functions.dart';

class menu_item_helper
{
  general_helper gen_helper = general_helper();
  ingredients_table_helper ing_helper = ingredients_table_helper();

  // -Adds a menu item to the database
  // -A menu_item_obj will get passed in, this object mirrors a row from the menu_items table
  // -If the menu item is a smoothie, it will get added three different times (small, medium, large)
  //    and will add its ingredients to the ingredients_table table
  // -If it is not a smoothie, then it will just be added as is to the menu_items table
  Future<void> add_menu_item(menu_item_obj new_item) async
  {
    HttpsCallable getItemID = FirebaseFunctions.instance.httpsCallable('getLastMenuItemID');
    HttpsCallable getIngrID = FirebaseFunctions.instance.httpsCallable('getLastIngredientsTableID');
    HttpsCallable addMenuItem = FirebaseFunctions.instance.httpsCallable('addMenuItem');

    final itemIDQuery = await getItemID();
    List<dynamic> data = itemIDQuery.data;
    int new_id = data[0]['menu_item_id'];

    if(new_item.type == "smoothie")
    {
      final ingrIDQuery = await getIngrID();
      data = ingrIDQuery.data;
      int last_ingr_id = data[0]['row_id'];

      String smoothie_name = new_item.menu_item;
      double item_price = new_item.item_price;
      int amount_in_stock = new_item.amount_in_stock;
      for(int i = 1; i <= 3; i++)
      {
        new_item.menu_item_id = new_id + i;
        if(i == 1)
        {
          new_item.menu_item = smoothie_name +  " small";
          new_item.item_price = item_price - 2.40;
          new_item.amount_in_stock = amount_in_stock * 2;
          for(String ingredient in new_item.ingredients) {
            last_ingr_id += 1;
            ingredient_obj ingr_obj = ingredient_obj(last_ingr_id, new_item.menu_item, ingredient, i);
            ing_helper.add_ingredient_row(ingr_obj);
          }
        }
        else if(i == 2)
        {
          new_item.menu_item = smoothie_name +  " medium";
          new_item.item_price = item_price;
          new_item.amount_in_stock = amount_in_stock;
          for(String ingredient in new_item.ingredients) {
            last_ingr_id += 1;
            ingredient_obj ingr_obj = ingredient_obj(last_ingr_id, new_item.menu_item, ingredient, i);
            ing_helper.add_ingredient_row(ingr_obj);
          }
        }
        else
        {
          new_item.menu_item = smoothie_name +  " large";
          new_item.item_price = item_price + 2;
          new_item.amount_in_stock = amount_in_stock * 2 ~/ 3;
          for(String ingredient in new_item.ingredients) {
            last_ingr_id += 1;
            ingredient_obj ingr_obj = ingredient_obj(last_ingr_id, new_item.menu_item, ingredient, i);
            ing_helper.add_ingredient_row(ingr_obj);
          }
        }
        String values = new_item.get_values();
        await addMenuItem.call({'values':  values});
      }
    }
    else
    {
      new_item.menu_item_id = new_id + 1;
      String values = new_item.get_values();
      await addMenuItem.call({'values':  values});
    }

  }

  Future<void> deleteMenuItem(int menu_item_id) async
  {
    String menu_item = await gen_helper.get_item_name(menu_item_id);
    HttpsCallable remover = FirebaseFunctions.instance.httpsCallable('deleteMenuItem');
    await remover.call({'emnu_item': menu_item});
  }
}
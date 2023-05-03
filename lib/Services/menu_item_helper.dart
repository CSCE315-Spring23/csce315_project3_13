import 'package:csce315_project3_13/Services/general_helper.dart';
import 'package:csce315_project3_13/Services/ingredients_table_helper.dart';
import '../Models/models_library.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// A helper class for menu item-related functions.
class menu_item_helper
{
  general_helper gen_helper = general_helper();
  ingredients_table_helper ing_helper = ingredients_table_helper();
  
  // -Adds a menu item to the database
  // -A menu_item_obj will get passed in, this object mirrors a row from the menu_items table
  // -If the menu item is a smoothie, it will get added three different times (small, medium, large)
  //    and will add its ingredients to the ingredients_table table
  // -If it is not a smoothie, then it will just be added as is to the menu_items table
  /// Adds a menu item to the database. A [menu_item_obj] object is passed in, which mirrors a row from the menu_items table. If the menu item is a smoothie, it will be added three different times (small, medium, large) and its ingredients will be added to the ingredients_table table. If it is not a smoothie, then it will just be added as is to the menu_items table.
  ///
  /// Returns a [Future] of [void].
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

  /// Edits the ingredients of a smoothie menu item.
  /// `menu_item_id` - The ID of the menu item to edit.
  /// `new_ingredients` - A map of ingredient names to their new amounts.
  Future<void> edit_smoothie_ingredients(int menu_item_id, Map<String, int> new_ingredients) async
  {
    Map<String, int> current_ingredients = await gen_helper.get_smoothie_ingredients(menu_item_id);
    String menu_item_name = await gen_helper.get_item_name(menu_item_id);

    for(MapEntry<String, int> ingredient in new_ingredients.entries) {
      if(current_ingredients.containsKey(ingredient.key)) {
        int row_id = await gen_helper.get_ingredient_row_id(menu_item_name, ingredient.key);
        if(ingredient.value == 0) { // Remove the ingredient from the smoothie
          HttpsCallable remover = FirebaseFunctions.instance.httpsCallable('deleteIngredientsTableRow');
          await remover.call({'row_id': row_id});
        } else if(current_ingredients[ingredient.key] == ingredient.value) {} // Leave it alone if the values are the same
        else { // Update the ingredient amount
          HttpsCallable updater = FirebaseFunctions.instance.httpsCallable('updateIngredientsTableRow');
          await updater.call({
            'row_id': row_id,
            'new_amount': ingredient.value
          });
        }
      } else { // Doesn't exist yet, so add it
        HttpsCallable adder = FirebaseFunctions.instance.httpsCallable('insertIntoIngredientsTable');
        HttpsCallable getIngrID = FirebaseFunctions.instance.httpsCallable('getLastIngredientsTableID');
        final ingrIDQuery = await getIngrID();
        List<dynamic> data = ingrIDQuery.data;
        int last_ingr_id = data[0]['row_id'];
        ingredient_obj new_ing = ingredient_obj(last_ingr_id + 1, menu_item_name, ingredient.key, ingredient.value);
        await adder.call({'values': new_ing.get_values()});
      }
    }
  }

  /// Edits the price of a menu item.
  /// `menu_item_id` - The ID of the menu item to edit.
  /// `new_price` - The new price for the menu item.
  Future<void> edit_item_price(int menu_item_id, double new_price) async
  {
    HttpsCallable editor = FirebaseFunctions.instance.httpsCallable('editItemPrice');
    await editor.call({
      'menu_item_id': menu_item_id,
      'new_price': new_price
    });
  }

  /// Deletes a menu item.
  ///
  /// `menu_item_id` - The ID of the menu item to delete.
  Future<void> delete_menu_item(int menu_item_id) async
  {
    String menu_item = await gen_helper.get_item_name(menu_item_id);
    String type = await gen_helper.get_item_type(menu_item_id);
    if(type == "smoothie") {
      menu_item = menu_item.substring(0, menu_item.length - 6);
    }
    HttpsCallable remover = FirebaseFunctions.instance.httpsCallable('deleteMenuItem');
    await remover.call({'menu_item': menu_item});
  }

  /// Gets information about all smoothie menu items.
  ///
  /// Returns a list of `menu_item_obj` objects containing information about each menu item.
  Future<List<menu_item_obj>> getAllSmoothiesInfo() async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getAllSmoothieInfo');
    final smoothie_query = await callable();
    List result = smoothie_query.data;
    List<menu_item_obj> items = [];

    for (int i = 0; i < result.length; i++)
    {
      String item_price_str = result[i]['item_price'];
      items.add(menu_item_obj(result[i]['menu_item_id'], result[i]['menu_item'], double.parse(item_price_str.replaceAll('\$', '')), 0, 'smoothie', 'available', []));
    }

    return items;
  }

  /// Fetches all snack menu items from Firebase and returns them as a list of [menu_item_obj].
  ///
  /// Returns a [Future] that resolves to a list of [menu_item_obj], representing all available snack menu items.
  Future<List<menu_item_obj>> getAllSnackInfo() async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getAllSnacksInfo');
    final snack_query = await callable();
    List result = snack_query.data;
    List<menu_item_obj> items = [];

    for (int i = 0; i < result.length; i++)
    {
      String item_price_str = result[i]['item_price'];
      items.add(menu_item_obj(result[i]['menu_item_id'], result[i]['menu_item'], double.parse(item_price_str.replaceAll('\$', '')), 0, 'Snack', 'available', []));
    }

    return items;
  }

  /// Fetches all addon menu items from Firebase and returns them as a list of [menu_item_obj].
  ///
  /// Returns a [Future] that resolves to a list of [menu_item_obj], representing all available addon menu items.
  Future<List<menu_item_obj>> getAllAddonInfo() async
  {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getAllAddonInfo');
    final addon_query = await callable();
    List result = addon_query.data;
    List<menu_item_obj> items = [];

    for (int i = 0; i < result.length; i++)
    {
      String item_price_str = result[i]['item_price'];
      items.add(menu_item_obj(result[i]['menu_item_id'], result[i]['menu_item'], double.parse(item_price_str.replaceAll('\$', '')), 0, 'Addon', 'available', []));
    }

    return items;
  }
}
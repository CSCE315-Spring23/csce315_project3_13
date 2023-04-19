import 'package:csce315_project3_13/Models/models_library.dart';

import '../../../Models/Order Models/addon_order.dart';

/// Represents a smoothie order that includes a smoothie, size, and a vector of addons.
class smoothie_order
{
  /// The type of smoothie.
  String smoothie;

  /// The size of the smoothie.
  String curr_size;

  /// Any additional addons added to the smoothie.
  List<addon_order> Addons = [];

  /// The index of the table where the order is being placed.
  int table_index = 0;

  /// Price of the smoothie, not including addons
  double curr_price = 0.00;

  /*
  int id_small = 0;
  int id_medium = 0;
  int id_large = 0;

  double price_small = 0;
  double price_medium = 0;
  double price_large = 0;


  smoothie_order(menu_item_obj small_smoothie, menu_item_obj med_smoothie, menu_item_obj large_smoothie, int table)
  {
    price_small = small_smoothie.item_price;
    id_small = small_smoothie.menu_item_id;
    price_medium = med_smoothie.item_price;
    id_medium = med_smoothie.menu_item_id;
    price_large = large_smoothie.item_price;
    id_large = large_smoothie.menu_item_id;
    curr_price = price_medium;
    curr_size = "medium";
  }
*/

  /// * Constructs a SmoothieOrder object with the given smoothie name and sets the size to "Medium".
  /// @param smoothie_name the name of the smoothie
  smoothie_order({required this.smoothie, required this.curr_size, required this.curr_price, required this.table_index});

  /// * Sets the name of the smoothie order
  /// @param smoothie_size the size of the smoothie
  void setSmoothieName(String name)
  {
    smoothie = name;
  }

  /// * Sets the size of the smoothie order to the given size.
  /// @param smoothie_size the size of the smoothie
  void setSmoothieSize(String smoothie_size)
  {
    curr_size = smoothie_size;
  }

  /// Sets Price of smoothies, not including addons
  void setSmoothiePrice(double smoothie_price)
  {
    curr_price = smoothie_price;
  }

  /// Adds the given addon to the smoothie order.
  /// @param addon_name the name of the addon
  void addAddon(addon_order new_addon)
  {
    for (addon_order addon in Addons)
      {
        if (addon.name == new_addon.name)
          {
            addon.amount += 1;
            return;
          }
      }
    Addons.add(new_addon);
  }

  void removeAddon(int index)
  {
    Addons.removeAt(index);
  }

  /// * Returns a string representation of the smoothie and size.
  /// @return the smoothie and size
  String getSmoothie()
  {
    return ("$smoothie $curr_size");
  }

  String getName()
  {
    return smoothie;
  }

  String getSize()
  {
    return curr_size;
  }

  /// * Returns a vector of the addons in the smoothie order.
  /// @return the addons in the smoothie order
  List<addon_order> getAddons()
  {
    return Addons;
  }

  double getCost(){
    double addon_cost = 0;
    for(addon_order addon in Addons)
      {
        addon_cost += addon.price;
      }
    return addon_cost + curr_price;
  }

  ///Sets the table index of the smoothie order to the specified value.
  ///@param index the table index to set for the smoothie order
  void setTableIndex(int index) {
    table_index = index;
  }

  ///Gets the table index of the smoothie order.
  ///@return the table index of the smoothie order

  int getTableIndex() {
    return table_index;
  }
}

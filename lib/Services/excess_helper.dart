import 'dart:core';
import 'package:cloud_functions/cloud_functions.dart';

class excess_helper
{
  Future<double> inventory_calculation(String date, String ingredient) async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getExcessInventoryData');
    final res = await getter.call({
      'date': date,
      'ingredient': ingredient
    });
    List<dynamic> data = res.data;

    if(data.isEmpty) {
      return 0.0;
    } else {
      int curr_amount = data[0]['amount_inv_stock'];
      int unit_amount = data[0]['amount_ordered'];
      int conversion = data[0]['conversion'];
      int add_amount = 0;

      for (int i = 1; i < data.length; i++) {
        print("curr amt = $curr_amount");
        print("adding...");
        print(data[i]['amount_inv_stock']);
        add_amount = data[i]['amount_inv_stock'];
        curr_amount += add_amount;
      }

      int ordered_amount = unit_amount * conversion;
      double ordered_percent = curr_amount / ordered_amount;

      print("$ingredient has $ordered_percent (ratio) stock left.");
      return ordered_percent;
    }
  }

  Future<List<String>> excess_report(String date) async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getExcessIngredients');
    final res = await getter.call({
      'date': date,
    });
    List<dynamic> data = res.data;

    String curr_ingredient = "";
    double curr_percent = 0.0;
    List<String> excess = [];

    for(int i = 0; i < data.length; i++) {
      curr_ingredient = data[i]['ingredient'];
      print("Calling inv calc with $date and $curr_ingredient");
      curr_percent = await inventory_calculation(date, curr_ingredient);
      if (curr_percent >= 0.9) {
        excess.add(curr_ingredient);
      }
    }

    print("Items in excess:");
    for(int i = 0; i < excess.length; i++) {
      print(excess[i]);
    }
    return excess;
  }
}
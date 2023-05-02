import 'dart:core';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:csce315_project3_13/Services/general_helper.dart';

class reports_helper
{

  general_helper gen_helper = general_helper();

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

      for (int i = 1; i < data.length; i++) {
        curr_amount = curr_amount + int.parse(data[i]['amount_inv_stock']);
      }

      int ordered_amount = unit_amount * conversion;
      double ordered_percent = curr_amount / ordered_amount;

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
      curr_percent = await inventory_calculation(date, curr_ingredient);
      if (curr_percent >= 0.9) {
        excess.add(curr_ingredient);
      }
    }

    return excess;
  }
}
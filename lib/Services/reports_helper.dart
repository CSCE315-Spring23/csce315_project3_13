import 'dart:collection';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:csce315_project3_13/Services/general_helper.dart';
import '../Models/models_library.dart';

class reports_helper
{

  general_helper gen_helper = general_helper();

  Future<double> get_z_report(String date) async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getZReport');
    final res = await getter.call({'date': date});
    List<dynamic> data = res.data;

    if(data.length == 0) {
      return 0.0;
    } else {
      String money = data[0]['sales'];
      double amount = double.parse(money.substring(1, money.length));
      return amount;
    }
  }

  Future<Map<String, double>> get_all_z_reports() async
  {
    HttpsCallable getter = FirebaseFunctions.instance.httpsCallable('getAllZReports');
    final res = await getter();
    Map<String, double> z_reports = {};
    List<dynamic> data = res.data;
    for(int i = 0; i < data.length; ++i) {
      String money = data[i]['sales'];
      double amount = double.parse(money.substring(1, money.length));
      z_reports.update(data[i]['date_field_string'], (value) => amount, ifAbsent: () => amount);
      print(data[i]['date_field_string'] + "    " + data[i]['sales']);
    }

  return z_reports;
  }

  Future<void> update_x_report(double amount) async
  {
    String date = await gen_helper.get_current_date();
    double new_amount = (await get_z_report(date) + amount);

    if(new_amount - amount == 0) {
      HttpsCallable updater = FirebaseFunctions.instance.httpsCallable('makeZReport');
      print(date + "    new  ${new_amount}");
      await updater.call({
        'date': date,
        'amount': new_amount
      });
    } else {
      HttpsCallable updater = FirebaseFunctions.instance.httpsCallable('updateXReport');
      print(date + "     ${new_amount}");
      await updater.call({
        'date': date,
        'amount': new_amount
      });
    }

  }

  Future<List<what_sales_together_row>> what_sales_together(String date1,
      String date2) async
  {
    print("Called what sales function");
    Map<pair, int> pairs = {};
    HttpsCallable get_items = FirebaseFunctions.instance.httpsCallable(
        'getItemsInOrder');
    final res = await get_items.call({
      'date1': date1,
      'date2': date2
    });
    List<dynamic> data = res.data;
    print("got items");
    print("data length = " + data.length.toString());
    for (int index = 0; index < data.length; ++index) {
      print("Current index = " + index.toString());
      List<dynamic> l = data[index]['item_ids_in_order'];
      l.sort();
      // print("l length = ");
      // print(l.length);
      if (l.length > 1) {
        for (int i = 0; i < l.length; ++i) {
          // print("looping 1");
          String type = await gen_helper.get_item_type(l[i]);
          // if(type == "smoothie") {
            pair curr_pair = pair(l[i], null);
            for (int j = i + 1; j < l.length; ++j) {
              // print("looping 2");
              curr_pair.right = l[j];
              pairs.update(curr_pair, (value) => value + 1, ifAbsent: () => 1);
            }
          // }
        }
      }
    }
    print("reached here 1");
    pairs = Map.fromEntries(pairs.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value)));
    for (MapEntry<pair, int> e in pairs.entries) {
      print("${e.key.left}, ${e.key.right} \t ${e.value}");
    }

    print("reached here 2");

    List<what_sales_together_row> report = [];
    for (MapEntry<pair, int> e in pairs.entries) {
      int id1 = e.key.left;
      int id2 = e.key.right;
      String item1 = await gen_helper.get_item_name(id1);
      String item2 = await gen_helper.get_item_name(id2);
      int num = e.value;
      what_sales_together_row row = what_sales_together_row(
          id1, item1, id2, item2, num);
      report.add(row);
    }
    print("reached here 3");

    return report;
  }




}
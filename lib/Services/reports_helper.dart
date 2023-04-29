import 'dart:collection';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:csce315_project3_13/Services/general_helper.dart';
import '../Models/models_library.dart';
import 'dart:math';

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

  Future<List<what_sales_together_row>> what_sales_together(String date1, String date2) async
  {
    print("Called what sales function");
    Map<String, int> pairs = {};

    HttpsCallable get_items = FirebaseFunctions.instance.httpsCallable('getItemsInOrder');
    final res = await get_items.call({
      'date1': date1,
      'date2': date2
    });
    List<dynamic> order_data = res.data;

    Map<int, List<dynamic>> item_info = await gen_helper.get_all_menu_item_info();

    print("got all item info");
    for (int index = 0; index < order_data.length; ++index) {
      List<dynamic> l = order_data[index]['item_ids_in_order'];
      l.sort();
      if (l.length > 1) {
        for (int i = 0; i < l.length; ++i) {
          if(l[i] < 1000) {
            if(item_info[l[i]]![1] == "smoothie") {
              for(int j = i + 1; j < l.length; ++j) {
                if(l[j] < 1000) {
                  if(item_info[l[j]]![1] == "smoothie") {
                    pair curr_pair = pair(l[i], l[j]);
                    pairs.update(curr_pair.toString(), (value) => value + 1, ifAbsent: () => 1);
                  }
                }
              }
            }
          }
        }
      }
    }
    print("reached here 1");
    pairs = Map.fromEntries(pairs.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value)));

    List<what_sales_together_row> report = [];
    for (MapEntry<String, int> e in pairs.entries) {
      pair p = pair.fromString(e.key);
      print("${p.left}, ${p.right} \t ${e.value}");
      int id1 = p.left;
      String item1 = item_info[id1]![0];
      int id2 = p.right;
      String item2 = item_info[id2]![0];
      int num = e.value;
      what_sales_together_row row = what_sales_together_row(id1, item1, id2, item2, num);
      report.add(row);
    }

    return report;

  }

  Future<List<sales_report_row>> generate_sales_report(String date1, String date2) async {
    Map<int, int> sales = {};
    Map<int, List<dynamic>> item_info = await gen_helper.get_all_menu_item_info();

    HttpsCallable get_items = FirebaseFunctions.instance.httpsCallable('getItemsInOrder');
    final res = await get_items.call({
      'date1': date1,
      'date2': date2
    });
    List<dynamic> order_data = res.data;

    for (int index = 0; index < order_data.length; ++index) {
      List<dynamic> l = order_data[index]['item_ids_in_order'];
      for(dynamic id in l) {
        if(id < 1000) {
          sales.update(id as int, (value) => value + 1, ifAbsent: () => 1);
        }
      }
    }

    List<sales_report_row> report = [];

    for(MapEntry<int, int> e in sales.entries) {
      int id = e.key;
      String type = item_info[id]![1];
      String item_name = item_info[id]![0];
      int amount_sold = e.value;
      double total_revenue = item_info[id]![2] * amount_sold;
      total_revenue = double.parse(total_revenue.toStringAsFixed(2));
      sales_report_row row = sales_report_row(type, id, item_name, amount_sold, total_revenue);
      report.add(row);
      print("$item_name \t \$$total_revenue");
    }


    return report;
  }


}
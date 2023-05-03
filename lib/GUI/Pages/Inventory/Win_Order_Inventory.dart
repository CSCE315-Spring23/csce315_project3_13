import 'dart:collection';

import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:csce315_project3_13/Services/inventory_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Models/models_library.dart';
import 'package:flutter/material.dart';
import '../../../Services/reports_helper.dart';
import '../../Components/Page_Header.dart';
import 'Win_View_Inventory.dart';

class Win_Order_Inventory extends StatefulWidget {
  static const String route = '/view-order-manager';
  const Win_Order_Inventory({Key? key}) : super(key: key);

  @override
  State<Win_Order_Inventory> createState() => _Win_Order_Inventory_State();
}


class _Win_Order_Inventory_State extends State<Win_Order_Inventory> {

  //Keeps track of whether to update name or not
  bool call_set_translation = true;

  google_translate_API _google_translate_api = google_translate_API();

  //Strings for display
  List<String> list_page_texts_originals = [
    "Inventory Item Management",
    "Edit Item Amount",
    "New Amount",
    "CANCEL",
    "CONFIRM",
    "Not enough inventory to satisfy the requested change.",
    "OK",
    "Unable to change amount for this item.",
    "Successfully Removed Item",
    "Unable to remove inventory item",
    "Confirm Item Deletion",
    "Are you sure you want to delete",
    "Stock",
    "Remove from Inventory",
    "Edit Amount",
    "Successfully Added Item",
    "Unable to add item",
    "New Inventory Item Creation",
    "Ingredient Name",
    "Amount in Stock",
    "Amount Ordered",
    "Unit",
    "Date Ordered",
    "Expiration Date",
    "Conversion",
    "ADD ITEM",
    "available",
    "Return to Manager View",
    "Add Inventory"
  ];
  List<String> list_page_texts = [
    "Inventory Item Management",
    "Edit Item Amount",
    "New Amount",
    "CANCEL",
    "CONFIRM",
    "Not enough inventory to satisfy the requested change.",
    "OK",
    "Unable to change amount for this item.",
    "Successfully Removed Item",
    "Unable to remove inventory item",
    "Confirm Item Deletion",
    "Are you sure you want to delete",
    "Stock",
    "Remove from Inventory",
    "Edit Amount",
    "Successfully Added Item",
    "Unable to add item",
    "New Inventory Item Creation",
    "Ingredient Name",
    "Amount in Stock",
    "Amount Ordered",
    "Unit",
    "Date Ordered",
    "Expiration Date",
    "Conversion",
    "ADD ITEM",
    "available",
    "Return to Manager View",
    "Add Inventory"
  ];
  String text_page_header = "Inventory Item Management";
  String text_item_amount = "Edit Item Amount";
  String text_hint_new_amount = "New Amount";
  String text_cancel_button = "CANCEL";
  String text_confirm_button = "CONFIRM";
  String text_not_enough_inventory = "Not enough inventory to satisfy the requested change.";
  String text_ok_button = "OK";
  String text_unable_to_change_amount = "Unable to change amount for this item.";
  String text_message_text_rem = "Successfully Removed Item";
  String text_message_text_rem_alt = "Unable to remove inventory item";
  String text_confirm_item_deletion = "Confirm Item Deletion";
  String text_certain_you_want_del = "Are you sure you want to delete";
  String text_stock = "Stock";
  String text_remove_from_inventory = "Remove from Inventory";
  String text_edit_amount = "Edit Amount";
  String text_message_text_add = "Successfully Added Item";
  String text_message_text_add_alt = "Unable to add item";
  String text_new_item_creation = "New Inventory Item Creation";
  String text_ingredient_name = "Ingredient Name";
  String text_amount_in_stock = "Amount in Stock";
  String text_amount_ordered = "Amount Ordered";
  String text_unit = "Unit";
  String text_date_ordered = "Date Ordered";
  String text_expiration_date = "Expiration Date";
  String text_conversion = "Conversion";
  String text_add_item = "ADD ITEM";
  String text_available = "available";
  String text_ret_man = "Return to Manager View";
  String text_add_inventory = "Add Inventory";






  int visibility_ctrl = 0;
  bool _isLoading = true;
  Map<String, num> inventoryItems = {};
  Map<dynamic, num> reportItems = {};
  inventory_item_helper inv_helper = inventory_item_helper();
  reports_helper report = reports_helper();

  Future<void> getData_no_reload() async {
    print("Building Page...");
    inventoryItems = await inv_helper.get_order_items();
    reportItems = await report.generate_restock_report();
    print("Obtained Inventory...");
  }

  Future<void> getData() async {
    print("Building Page...");
    inventoryItems = await inv_helper.get_order_items();
    reportItems = await report.generate_restock_report();
    print("Obtained Inventory...");
    setState(() {
      _isLoading = false;
    });
  }


  Widget itemList(Map<String, num> items1, Map<dynamic, num> items2, Color tile_color, Color _text_color, Color _icon_color) {
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items1.entries.length,
            itemBuilder: (context, index) {
              final entry = items1.entries.elementAt(index);
              return Card(
                child: ListTile(
                  tileColor: tile_color.withAlpha(200),
                  minVerticalPadding: 5,
                  onTap: () {},
                  leading: SizedBox(
                    width: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: _text_color.withAlpha(200),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  subtitle: Text(
                    text_stock + ": ${entry.value}",
                    style: TextStyle(
                      fontSize: 20,
                      color: _text_color.withAlpha(122),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  trailing: SizedBox(
                    width: 150,
                    child: IconButton(
                      tooltip: "Order",
                      icon: const Icon(Icons.add),
                      color: _text_color.withAlpha(122),
                      onPressed: () {
                        //_menu_info.removeAt(index);
                        // editInventoryItem(items1, entry.key, entry.value);
                        newItemSubWin(entry.key);
                      },
                      iconSize: 35,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: 1,
          height: double.infinity,
          color: Colors.grey.shade400,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items2.entries.length,
            itemBuilder: (context, index) {
              final entry = items2.entries.elementAt(index);
              return Card(
                child: ListTile(
                  tileColor: tile_color.withAlpha(200),
                  minVerticalPadding: 5,
                  onTap: () {},
                  leading: SizedBox(
                    width: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: _text_color.withAlpha(200),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  subtitle: Text(
                    text_stock + ": ${entry.value}",
                    style: TextStyle(
                      fontSize: 20,
                      color: _text_color.withAlpha(122),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  trailing: SizedBox(
                    width: 150,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  void newItemSubWin(String itemName)
  {
    TextEditingController _ingredient_name = TextEditingController();
    TextEditingController _amount_inv_stock = TextEditingController();
    TextEditingController _amount_ordered = TextEditingController();
    TextEditingController _unit = TextEditingController();
    TextEditingController _date_ordered = TextEditingController();
    TextEditingController _expiration_date = TextEditingController();
    TextEditingController _conversion = TextEditingController();

    Icon message_icon = const Icon(Icons.check);
    String message_text = text_message_text_add;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New Order"),
          content: SizedBox(
            width: 400,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    controller: _amount_ordered,
                    decoration:  InputDecoration(
                      hintText: text_amount_ordered + "...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                ),
                TextFormField(
                  controller: _date_ordered,
                  decoration: InputDecoration(
                    hintText: text_date_ordered + "...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      throw Exception('Please enter a value');
                    }
                    final currentDate = DateTime.now();
                    final dateOrdered = DateTime.parse(value);
                    if (dateOrdered.isBefore(currentDate)) {
                      throw Exception('Date ordered cannot be before the current date');
                    }
                  },
                ),
                TextFormField(
                  controller: _expiration_date,
                  decoration: InputDecoration(
                    hintText: text_expiration_date + "...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      throw Exception('Please enter a value');
                    }
                    final currentDate = DateTime.now();
                    final expirationDate = DateTime.parse(value);
                    if (expirationDate.isBefore(currentDate)) {
                      throw Exception('Expiration date cannot be before the current date');
                    }
                  },
                ),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(text_cancel_button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("ORDER"),
              onPressed: () async {
                try {
                  Map<String, int> map = HashMap();
                  map = await inv_helper.place_order(itemName);
                  final entry = map.entries.elementAt(0);
                  String unit = entry.key;
                  int conversion = entry.value;
                  print(unit);
                  print(conversion);
                  inventory_item_obj new_item = inventory_item_obj(
                      0,
                      text_available,
                      itemName,
                      conversion * int.parse(_amount_ordered.text),
                      int.parse(_amount_ordered.text),
                      unit,
                      _date_ordered.text,
                      _expiration_date.text,
                      conversion
                  );
                  print("done");
                  await inv_helper.add_inventory_row(new_item);
                  getData();
                  setState(() {

                  });
                  Navigator.pop(context);
                }
                catch(exception)
                {
                  print(exception);
                  message_icon = const Icon(Icons.error_outline_outlined);
                  message_text = text_message_text_add_alt;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: message_icon,
                        content: Text("Could not place order"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(text_ok_button),
                          ),
                        ],
                      );
                    },
                  );
                }
                finally{
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: message_icon,
                          content: Text(message_text),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text(text_ok_button))
                          ],
                        );
                      });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }


  Widget tab(Function tabChange, String tab_text, Color backgroundColor, Color headColor)
  {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        minimumSize: MaterialStateProperty.all(Size(100, 65)),
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
      ),
      onPressed: (){

      }, child: Text(tab_text),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context){
    final _color_manager = Color_Manager.of(context);




    // ToDo Implement the below translation functionality
    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {
      call_set_translation = false;

      //set the new Strings here
      list_page_texts = (await _google_translate_api.translate_batch(list_page_texts_originals,_translate_manager.chosen_language));
      text_page_header = list_page_texts[0];
      text_item_amount = list_page_texts[1];
      text_hint_new_amount = list_page_texts[2];
      text_cancel_button = list_page_texts[3];
      text_confirm_button = list_page_texts[4];
      text_not_enough_inventory = list_page_texts[5];
      text_ok_button = list_page_texts[6];
      text_unable_to_change_amount = list_page_texts[7];
      text_message_text_rem = list_page_texts[8];
      text_message_text_rem_alt = list_page_texts[9];
      text_confirm_item_deletion = list_page_texts[10];
      text_certain_you_want_del = list_page_texts[11];
      text_stock = list_page_texts[12];
      text_remove_from_inventory = list_page_texts[13];
      text_edit_amount = list_page_texts[14];
      text_message_text_add = list_page_texts[15];
      text_message_text_add_alt = list_page_texts[16];
      text_new_item_creation = list_page_texts[17];
      text_ingredient_name = list_page_texts[18];
      text_amount_in_stock = list_page_texts[19];
      text_amount_ordered = list_page_texts[20];
      text_unit = list_page_texts[21];
      text_date_ordered = list_page_texts[22];
      text_expiration_date = list_page_texts[23];
      text_conversion = list_page_texts[24];
      text_add_item = list_page_texts[25];
      text_available = list_page_texts[26];
      text_ret_man = list_page_texts[27];
      text_add_inventory = list_page_texts[28];

      await  getData_no_reload();
      List<String> keys_list = inventoryItems.keys.toList();
      keys_list = (await _google_translate_api.translate_batch(keys_list,_translate_manager.chosen_language));

      Map<String, num> new_inventoryItems = {};

      int current_keys_index = 0;
      inventoryItems.forEach((key, value) {
        new_inventoryItems[keys_list[current_keys_index]] = value;
        current_keys_index++;

      });
      inventoryItems = new_inventoryItems;




      setState(() {
      });
    }

    if(call_set_translation){
      set_translation();
    }else{
      call_set_translation = true;
    }

    //Translation functionality end





    return Scaffold(
      appBar: Page_Header(
        context: context,
        pageName: text_page_header,
        buttons: [
          IconButton(
            tooltip: text_ret_man,
            padding: const EdgeInsets.only(left: 25, right: 10),
            onPressed: ()
            {
              Navigator.pushReplacementNamed(context,Win_Manager_View.route);

            },
            icon: const Icon(Icons.close_rounded),
            iconSize: 40,
          ),],
      ),
      body: _isLoading ?  Center(
        child: SpinKitRing(color: _color_manager.primary_color) ,
      ) : Padding(
        padding: const EdgeInsets.only(bottom: 76),
        child: Stack(
          children: [
            Visibility(
              visible: visibility_ctrl == 0,
              child: itemList(inventoryItems,reportItems, _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
            ),
          ],
        ),
      ),
      backgroundColor: _color_manager.background_color,
      bottomSheet: Container
        (
        height: 75,
        color: _color_manager.primary_color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              tooltip: "Return to Inventory Management",
              padding: const EdgeInsets.only(left: 75, right: 10, top: 15),
              onPressed: ()
              {
                Navigator.pushReplacementNamed(context,Win_View_Inventory.route);
              },
              icon: const Icon(Icons.close_rounded),
              iconSize: 40,
            ),
            Padding(
              padding: EdgeInsets.only(left: 500.0),
              child: Login_Button(
                onTap: () async {
                  try {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    await report.restock();
                    getData();
                    setState(() {

                    });
                    await Future.delayed(Duration(seconds: 2));
                    Navigator.pop(context); // Close the loading dialog
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text("Could not restock: $e"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                buttonWidth: 200,
                buttonName: 'Restock All Items',
              ),
            ),

            // Login_Button(
            //   onTap: () {
            //     newItemSubWin();
            //   },
            //   buttonWidth: 200,
            //   buttonName: 'Restock Report',
            // ),
          ],
        ),
      ),
    );
  }
}

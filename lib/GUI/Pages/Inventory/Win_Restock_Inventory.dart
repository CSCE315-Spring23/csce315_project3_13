import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Inventory/Win_Order_Inventory.dart';
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

class Win_Restock_Inventory extends StatefulWidget {
  static const String route = '/view-inventory-restock';
  const Win_Restock_Inventory({Key? key}) : super(key: key);

  @override
  State<Win_Restock_Inventory> createState() => _Win_Restock_Inventory_State();
}


class _Win_Restock_Inventory_State extends State<Win_Restock_Inventory> {

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
  Map<String, int> inventoryItems = {};
  reports_helper report = reports_helper();

  Future<void> getData_no_reload() async {
    print("Building Page...");
    inventoryItems = await report.generate_restock_report();

    print("Obtained Inventory...");
  }

  Future<void> getData() async {
    print("Building Page...");
    inventoryItems = await report.generate_restock_report();

    print("Obtained Inventory...");
    setState(() {
      _isLoading = false;
    });
  }




  Widget itemList(Map<String, int> items, Color tile_color, Color _text_color, Color _icon_color) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.entries.length,
      itemBuilder: (context, index) {
        final entry = items.entries.elementAt(index);
        return Card(
          child: ListTile(
            tileColor: tile_color.withAlpha(200),
            minVerticalPadding: 5,
            onTap: () {},
            leading: SizedBox(
              width: 300,
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
                  fontSize: 35,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            subtitle: Text(
              'Amount Stock Needed' + ": ${entry.value}",
              style: TextStyle(
                fontSize: 20,
                color: _text_color.withAlpha(122),
              ),
              textAlign: TextAlign.center,
            ),
            trailing: SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          ),
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

      Map<String, int> new_inventoryItems = {};

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
              child: itemList(inventoryItems, _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
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
              padding: const EdgeInsets.only(left: 25, right: 10, top: 10),
              onPressed: ()
              {
                Navigator.pushReplacementNamed(context,Win_View_Inventory.route);
              },
              icon: const Icon(Icons.close_rounded),
              iconSize: 40,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:csce315_project3_13/GUI/Pages/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/GUI/Pages/Sales%20Reports/What_Sales_Dialogue.dart';
import 'package:csce315_project3_13/Inherited_Widgets/What_Sales_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:csce315_project3_13/Services/reports_helper.dart';
import 'package:flutter/material.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Inherited_Widgets/Color_Manager.dart';
import '/../Models/models_library.dart';

class Win_What_Sales extends StatefulWidget {
  static const String route = '/view-what-sales';
  const Win_What_Sales({Key? key}) : super(key: key);

  @override
  State<Win_What_Sales> createState() => _Win_What_SalesState();
}

class _Win_What_SalesState extends State<Win_What_Sales> {

  bool call_set_translation = true;

  google_translate_API _google_translate_api = google_translate_API();

  //Strings for display
  List<String> list_page_texts_originals = ["What Sells Together", "Exit","Amount Sold Together", "Select Dates"];
  List<String> list_page_texts = ["What Sells Together", "Exit","Amount Sold Together","Select Dates"];
  String text_page_header = "What Sells Together";
  String text_exit_to = "Exit";
  String text_amount_sold_together = "Amount Sold Together";
  String text_reselect_dates = "Select Dates";

  int visibility_ctrl = 0;

  bool _isLoading = true;
  List<what_sales_together_row> row_items = [];
  reports_helper rep_helper = reports_helper();

  Future<void> getData_no_reload(What_Sales_Manager _manager) async {
    print("Building Page...");
    //ToDo uncomment below line when what_sales_together complete
    // row_items = await rep_helper.what_sales_together(_manager.date1, _manager.date2);

    //ToDo comment out below line when what_sales_together complete
    row_items = [what_sales_together_row(
        0, "Gladiator Smoothie", 1, "Bulk Smoothie", 3
    )];

    print("Obtained Inventory...");
  }

  Future<void> getData(What_Sales_Manager _manager) async {
    print("Building Page...");
    //ToDo uncomment below line when what_sales_together complete
    // row_items = await rep_helper.what_sales_together(_manager.date1, _manager.date2);

    //ToDo comment out below line when what_sales_together complete
     row_items = [what_sales_together_row(
        0, "Gladiator Smoothie", 1, "Bulk Smoothie", 3
    )];

    print("Obtained Inventory...");
    _isLoading = false;
    setState(() {

    });
  }



  Widget itemList(List<what_sales_together_row> items, Color tile_color, Color _text_color, Color _icon_color) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final entry = items[index];
        return Center(
          child: Card(
            child: ListTile(
              tileColor: tile_color.withAlpha(200),
              minVerticalPadding: 5,
              onTap: () {},
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      " " + entry.item1 + ", ",
                      style: TextStyle(
                        color: _text_color.withAlpha(200),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      " " + entry.item2 + " ",
                      style: TextStyle(
                        color: _text_color.withAlpha(200),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                 text_amount_sold_together + ": " + entry.num.toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: _text_color.withAlpha(122),
                ),
                textAlign: TextAlign.center,
              ),

            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);

    final _what_sales_manager = What_Sales_Manager.of(context);

    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {
      call_set_translation = false;

      list_page_texts = (await _google_translate_api.translate_batch(list_page_texts_originals,_translate_manager.chosen_language));
      text_page_header = list_page_texts[0];
      text_exit_to = list_page_texts[1];
      text_amount_sold_together = list_page_texts[2];
      text_reselect_dates = list_page_texts[3];

      await  getData_no_reload(_what_sales_manager);
      List<String> names_left = [];
      List<String> names_right = [];
      row_items.forEach((element) {
      names_left.add(element.item1);
      names_right.add(element.item2);
      });
      names_left = (await _google_translate_api.translate_batch(names_left,_translate_manager.chosen_language));
      names_right = (await _google_translate_api.translate_batch(names_right,_translate_manager.chosen_language));
      List<what_sales_together_row> item_row_new = [];
      int current_index = 0;
      row_items.forEach((element) {
        item_row_new.add(what_sales_together_row(
            row_items[current_index].id1, names_left[current_index], row_items[current_index].id2, names_right[current_index], row_items[current_index].num
        ));
        current_index++;
      });
      row_items = item_row_new;
      _isLoading = false;
      call_set_translation = false;
      setState(() {
      });
    }

    if(_what_sales_manager.set_dates) {
      if ((!_isLoading) && call_set_translation) {
        set_translation();
      }

      if ((_isLoading && call_set_translation)) {
        set_translation();
      } else if (call_set_translation == false) {
        call_set_translation = true;
      }
    }
    //Translation functions

    return Scaffold(
      appBar: Page_Header(
        context: context,
        pageName: text_page_header,
        buttons: [
          IconButton(
            tooltip: text_exit_to,
            padding: const EdgeInsets.only(left: 25, right: 10),
            onPressed: ()
            {
              //ToDo change to correct page to exit to
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
              child: itemList(row_items, _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
            ),
          ],
        ),
      ),
      backgroundColor: _color_manager.background_color,
      bottomNavigationBar: Login_Button(onTap: (){
        showDialog(context: context, builder: (BuildContext context) {
          return WhatSalesDialogue();
        }
        );
      }, buttonName: text_reselect_dates),
    );


  }
}

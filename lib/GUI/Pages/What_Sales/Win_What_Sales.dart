import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:csce315_project3_13/GUI/Pages/Manager_View/Win_Manager_View.dart';
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
  List<String> list_page_texts_originals = ["What Sells Together",];
  List<String> list_page_texts = ["What Sells Together",];
  String text_page_header = "What Sells Together";
  String text_exit_to_manager = "Exit to Manager View";

  int visibility_ctrl = 0;



  bool _isLoading = true;
  Map<pair, int> pairs_items = {};
  reports_helper rep_helper = reports_helper();
  String date1 = "01/20/2022";
  String date2 = "02/20/2022";

  Future<void> getData_no_reload() async {
    print("Building Page...");
    pairs_items = await rep_helper.what_sales_together(date1, date2);

    print("Obtained Inventory...");
  }

  Future<void> getData() async {
    print("Building Page...");
    pairs_items = await rep_helper.what_sales_together(date1, date2);

    print("Obtained Inventory...");
    setState(() {
      _isLoading = false;
    });
  }



  Widget itemList(Map<pair, int> items, Color tile_color, Color _text_color, Color _icon_color) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.entries.length,
      itemBuilder: (context, index) {
        final entry = items.entries.elementAt(index);
        return Center(
          child: Card(
            child: ListTile(
              tileColor: tile_color.withAlpha(200),
              minVerticalPadding: 5,
              onTap: () {},
              // leading: SizedBox(
              //   width: 300,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //   ),
              // ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Item Ids: ",
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
                      " " + entry.key.left.toString() + " ",
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
                      " " + entry.key.right.toString() + " ",
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
                "Amount Sold Together: " + entry.value.toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: _text_color.withAlpha(122),
                ),
                textAlign: TextAlign.center,
              ),
              // trailing: SizedBox(
              //   width: 300,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //
              //
              //     ],
              //   ),
              // ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);




    // ToDo Implement the below translation functionality
    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {
      call_set_translation = false;

      //set the new Strings here
      list_page_texts = (await _google_translate_api.translate_batch(list_page_texts_originals,_translate_manager.chosen_language));
      text_page_header = list_page_texts[0];

      await  getData_no_reload();
      List<String> keys_left = [];
      List<String> keys_right = [];

      List<pair> keys_pair_list = pairs_items.keys.toList();
      keys_pair_list.forEach((element) {
        keys_left.add(element.left.toString());
        keys_right.add(element.right.toString());
      });


      keys_left = (await _google_translate_api.translate_batch(keys_left,_translate_manager.chosen_language));
      keys_right = (await _google_translate_api.translate_batch(keys_left,_translate_manager.chosen_language));

      Map<pair, int> new_inventoryItems = {};




      int current_keys_index = 0;
      pairs_items.forEach((key, value) {
        new_inventoryItems[pair(keys_left[current_keys_index], keys_right[current_keys_index])] = value;
        current_keys_index++;
      });
      pairs_items = new_inventoryItems;




      setState(() {
      });
    }

    // if(call_set_translation){
    //   set_translation();
    // }else{
    //   call_set_translation = true;
    // }

    //Translation functionality end





    return Scaffold(
      appBar: Page_Header(
        context: context,
        pageName: text_page_header,
        buttons: [
          IconButton(
            tooltip: text_exit_to_manager,
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
              child: itemList(pairs_items, _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
            ),
          ],
        ),
      ),
      backgroundColor: _color_manager.background_color,
      // bottomSheet: Container
      //   (
      //   height: 75,
      //   color: _color_manager.primary_color,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Login_Button(
      //         onTap: () {
      //           newItemSubWin();
      //         },
      //         buttonWidth: 200,
      //         buttonName: text_add_inventory,
      //       ),
      //       // Login_Button(
      //       //   onTap: () {
      //       //     newItemSubWin('Snack');
      //       //   },
      //       //   buttonWidth: 200,
      //       //   buttonName: 'Add Snack',
      //       // ),
      //       // Login_Button(
      //       //   onTap: () {
      //       //     newItemSubWin('Addon');
      //       //   },
      //       //   buttonWidth: 200,
      //       //   buttonName: 'Add Addon',
      //       // ),
      //     ],
      //   ),
      // ),
    );


  }
}

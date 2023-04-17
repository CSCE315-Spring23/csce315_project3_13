import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_Add_Smoothie.dart';
import 'package:csce315_project3_13/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/Services/general_helper.dart';
import 'package:csce315_project3_13/Services/inventory_helper.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';
import 'package:csce315_project3_13/Services/view_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Colors/Color_Manager.dart';
import '../../../Models/models_library.dart';
import 'package:flutter/material.dart';
import '../../Components/Page_Header.dart';

class Win_View_Inventory extends StatefulWidget {
  static const String route = '/view-inventory-manager';
  const Win_View_Inventory({Key? key}) : super(key: key);

  @override
  State<Win_View_Inventory> createState() => _Win_View_Inventory_State();
}


class _Win_View_Inventory_State extends State<Win_View_Inventory> {
  int visibility_ctrl = 0;
  String title = 'Manage Smoothies';
  bool _isLoading = true;
  Map<String, num> inventoryItems = {};
  inventory_item_helper inv_helper = inventory_item_helper();

  void getData() async {
    print('Building Page...');
    inventoryItems = await inv_helper.get_inventory_items();
    print('Obtained Inventory...');
    setState(() {
      _isLoading = false;
    });
  }

  // INSERT INTO menu_items (menu_item_id, menu_item, item_price, amount_in_stock, type, status) VALUES(407, 'The Smoothie Squad Special small', 6.18, 60, 'smoothie', 'available')
  void confirmInventoryItemRemoval(String itemName) {
    Icon message_icon = const Icon(Icons.check);
    String message_text = 'Successfully Removed Item';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Item Deletion'),
          content: Text('Are you sure you want to delete $itemName ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('CONFIRM'),
              onPressed: () async {
                try {
                  await inv_helper.deleteInventoryItem(itemName);
                  getData();
                  setState(() {

                  });
                } catch (exception) {
                  print(exception);
                  message_icon = const Icon(Icons.error_outline_outlined);
                  message_text = 'Unable to remove inventory item';
                } finally {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: message_icon,
                        content: Text(message_text),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          )
                        ],
                      );
                    },
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget itemTable(Map<String, num> items) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.entries.length,
      itemBuilder: (context, index) {
        final entry = items.entries.elementAt(index);
        return Card(
          child: ListTile(
            onTap: () {},
            title: Text(
              entry.key,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 35,
              ),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              'Stock: ${entry.value}',
              style: const TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              tooltip: 'Remove from Inventory',
              icon: const Icon(Icons.delete),
              onPressed: () {
                confirmInventoryItemRemoval(entry.key);
              },
            ),
          ),
        );
      },
    );
  }



  // void newItemSubWin(String item_type,)
  // {
  //   TextEditingController _new_item_name = TextEditingController();
  //   TextEditingController _new_item_price = TextEditingController();
  //   TextEditingController _new_item_amount = TextEditingController();
  //   Icon message_icon = const Icon(Icons.check);
  //   String message_text = 'Successfully Added Item';
  //
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('New $item_type Creation'),
  //         content: SizedBox(
  //           width: 300,
  //           height: 250,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               TextFormField(
  //                 controller: _new_item_name,
  //                 decoration: const InputDecoration(hintText: 'Name...'),
  //               ),
  //               TextFormField(
  //                 controller: _new_item_price,
  //                 decoration: const InputDecoration(hintText: 'Price...'),
  //               ),
  //               TextFormField(
  //                 controller: _new_item_amount,
  //                 decoration: const InputDecoration(hintText: 'Amount in Stock...'),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('CANCEL'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('ADD ITEM'),
  //             onPressed: () async {
  //               try {
  //                 menu_item_obj new_item = menu_item_obj(0,
  //                     _new_item_name.text,
  //                     double.parse(double.parse(_new_item_price.text).toStringAsFixed(2)),
  //                     int.parse(_new_item_amount.text),
  //                     item_type == 'Snack' ? 'snack' : 'addon',
  //                     'available', []
  //                 );
  //                 item_helper.add_menu_item(new_item);
  //                 new_item.menu_item_id = await view_helper().get_item_id(_new_item_name.text);
  //
  //               }
  //               catch(exception)
  //               {
  //                 print(exception);
  //                 message_icon = const Icon(Icons.error_outline_outlined);
  //                 message_text = 'Unable to add item';
  //               }
  //               finally{
  //                 showDialog(
  //                     context: context,
  //                     builder: (BuildContext context) {
  //                       return AlertDialog(
  //                         title: message_icon,
  //                         content: Text(message_text),
  //                         actions: [
  //                           TextButton(
  //                               onPressed: (){
  //                                 Navigator.of(context).pop();
  //                               },
  //                               child: const Text('OK'))
  //                         ],
  //                       );
  //                     });
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
    return Scaffold(
      appBar: Page_Header(
        context: context,
        pageName: "Manage Inventory",
        buttons: [
          tab((){}, 'Manage Smoothies', _color_manager.background_color, _color_manager.primary_color),
          tab((){}, 'Manage Snacks', _color_manager.primary_color, _color_manager.primary_color),
          tab((){}, 'Manage Addons', _color_manager.primary_color, _color_manager.primary_color),
    ],),

      body: _isLoading ? const Center(
        child: CircularProgressIndicator() ,
          ) : Padding(
              padding: const EdgeInsets.only(bottom: 125),
              child: Stack(
                children: [
                    Visibility(
                      visible: visibility_ctrl == 0,
                      child: itemTable(inventoryItems),
                    ),
                  ],

              ),
            ),
      backgroundColor: _color_manager.background_color,
      bottomSheet: Container
      (
        height: 125,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Login_Button(
                onTap: () {
                  Navigator.pushReplacementNamed(context,Win_Add_Smoothie.route);
                },
                buttonWidth: 200,
                buttonName: 'Add Smoothie',
            ),
          ],
        ),
      ),
    );
  }
}
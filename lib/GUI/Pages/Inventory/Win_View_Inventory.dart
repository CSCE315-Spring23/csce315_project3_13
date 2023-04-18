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

  void editInventoryItem(Map<String, num> items, String itemName, num currentAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController amountController =
        TextEditingController(text: currentAmount.toString());
        return AlertDialog(
          title: const Text('Edit Item Amount'),
          content: TextFormField(
            controller: amountController,
            decoration: const InputDecoration(hintText: 'New Amount...'),
            keyboardType: TextInputType.number,
          ),
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
                Navigator.of(context).pop();
                try {
                  num changeAmount = int.parse(amountController.text) - currentAmount;
                  bool success = await inv_helper.edit_inventory_entry(
                      itemName, changeAmount);
                  if (!success) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Icon(Icons.error_outline_sharp),
                            content: const Text(
                                'Not enough inventory to satisfy the requested change.'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        });
                  } else {
                    setState(() {
                      items[itemName] = int.parse(amountController.text);
                    });
                  }
                } catch (exception) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Icon(Icons.error_outline_sharp),
                          content: const Text(
                              'Unable to change amount for this item.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'))
                          ],
                        );
                      });
                }
              },
            ),
          ],
        );
      },
    );
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
                  Navigator.pop(context);
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

  Widget itemList(Map<String, num> items, Color tile_color, Color _text_color, Color _icon_color) {
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
                // children: <Widget>[
                //   Text(
                //     'Item Name: ${entry.key}',
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold,
                //       fontStyle: FontStyle.italic,
                //       color: _text_color.withAlpha(75),
                //     ),
                //   ),
                // ],
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
              'Stock: ${entry.value}',
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
                children: [
                  IconButton(
                    tooltip: 'Remove from Inventory',
                    icon: const Icon(Icons.delete),
                    color: _text_color.withAlpha(122),
                    onPressed: () {
                      confirmInventoryItemRemoval(entry.key);
                    },
                    iconSize: 35,
                  ),
                  IconButton(
                    tooltip: 'Edit Amount',
                    icon: const Icon(Icons.add),
                    color: _text_color.withAlpha(122),
                    onPressed: () {
                      //_menu_info.removeAt(index);
                      editInventoryItem(items, entry.key, entry.value);
                    },
                    iconSize: 35,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void newItemSubWin()
  {
    TextEditingController _ingredient_name = TextEditingController();
    TextEditingController _amount_inv_stock = TextEditingController();
    TextEditingController _amount_ordered = TextEditingController();
    TextEditingController _unit = TextEditingController();
    TextEditingController _date_ordered = TextEditingController();
    TextEditingController _expiration_date = TextEditingController();
    TextEditingController _conversion = TextEditingController();

    Icon message_icon = const Icon(Icons.check);
    String message_text = 'Successfully Added Item';

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Inventory Item Creation'),
          content: SizedBox(
            width: 400,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _ingredient_name,
                  decoration:  InputDecoration(
                    hintText: 'Ingredient Name...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _amount_inv_stock,
                    decoration:  InputDecoration(
                      hintText: 'Amount in Stock...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                ),
                TextFormField(
                  controller: _amount_ordered,
                    decoration:  InputDecoration(
                      hintText: 'Amount Ordered...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                ),
                TextFormField(
                  controller: _unit,
                    decoration:  InputDecoration(
                      hintText: 'Unit...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                ),
                TextFormField(
                  controller: _date_ordered,
                    decoration:  InputDecoration(
                      hintText: 'Date Ordered...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                ),
                TextFormField(
                  controller: _expiration_date,
                    decoration:  InputDecoration(
                      hintText: 'Expiration Date...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                ),
                TextFormField(
                  controller: _conversion,
                    decoration:  InputDecoration(
                      hintText: 'Conversion...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ADD ITEM'),
              onPressed: () async {
                try {
                  inventory_item_obj new_item = inventory_item_obj(
                      0,
                      'available',
                      _ingredient_name.text,
                      int.parse(_amount_inv_stock.text),
                      int.parse(_amount_ordered.text),
                      _unit.text,
                      _date_ordered.text,
                      _expiration_date.text,
                      int.parse(_conversion.text)
                  );
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
                  message_text = 'Unable to add item';
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
                                child: const Text('OK'))
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
    return Scaffold(
      appBar: Page_Header(
        context: context,
        pageName: "Inventory Item Management",
        buttons: [
          IconButton(
            tooltip: "Return to Manager View",
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
            Login_Button(
              onTap: () {
                newItemSubWin();
              },
              buttonWidth: 200,
              buttonName: 'Add Inventory',
            ),
            // Login_Button(
            //   onTap: () {
            //     newItemSubWin('Snack');
            //   },
            //   buttonWidth: 200,
            //   buttonName: 'Add Snack',
            // ),
            // Login_Button(
            //   onTap: () {
            //     newItemSubWin('Addon');
            //   },
            //   buttonWidth: 200,
            //   buttonName: 'Add Addon',
            // ),
          ],
        ),
      ),
    );
  }
}
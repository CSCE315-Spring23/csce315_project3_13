import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_Add_Smoothie.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';
import 'package:csce315_project3_13/Services/view_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../Models/models_library.dart';
import 'package:flutter/material.dart';

class Win_View_Menu extends StatefulWidget {
  static const String route = '/view-menu-manager';
  const Win_View_Menu({Key? key}) : super(key: key);

  @override
  State<Win_View_Menu> createState() => _Win_View_Menu_State();
}


class _Win_View_Menu_State extends State<Win_View_Menu> {
  int visibility_ctrl = 0;
  String title = 'Manage Smoothies';
  bool _isLoading = true;
  List<menu_item_obj> _smoothie_items = [];
  List<menu_item_obj> _snack_items = [];
  List<menu_item_obj> _addon_items = [];
  menu_item_helper item_helper = menu_item_helper();
  TextEditingController new_price = TextEditingController();

  void getData() async {
    _smoothie_items = await item_helper.getAllSmoothiesInfo();
    _snack_items = await item_helper.getAllSnackInfo();
    _addon_items = await item_helper.getAllAddonInfo();
    setState(() {
      _isLoading = false;
    });
  }

  void editPrice(List<menu_item_obj> items, int id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item Price'),
          content: TextFormField(
            controller: new_price,
            decoration: const InputDecoration(hintText: 'New Price...'),
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
                  await item_helper.edit_item_price(
                      id, double.parse(new_price.text));
                  setState(() {
                    items[index].item_price  = double.parse(new_price.text);
                  });
                }
                catch (exception){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Icon(Icons.error_outline_sharp),
                          content: const Text('Unable to change price for this item.'),
                          actions: [
                            TextButton(
                                onPressed: (){
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
  void confirmRemoval(List<menu_item_obj> items, String item_name, int id, int index)
  {
    Icon message_icon = const Icon(Icons.check);
    String message_text = 'Successfully Removed Item';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Item Deletion'),
          content: Text(
              'Are you sure you want to delete $item_name ?'
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
                try {
                  await item_helper.delete_menu_item(id);
                  setState(() {
                    items.removeAt(index);
                  });
                }
                catch(exception)
                {
                  print(exception);
                  message_icon = const Icon(Icons.error_outline_outlined);
                  message_text = 'Unable to remove item item';
                }
                finally{
                  showDialog(
                      barrierDismissible: false,
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

  Widget itemTable(List<menu_item_obj> items, String type)
  {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
              child:  ListTile(
                minVerticalPadding: 5,
                onTap: () {},
                leading: SizedBox(
                  width: 300,

                  child: Text(
                    '${items[index].menu_item_id.toString()}',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    items[index].menu_item,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                subtitle: Text(
                  '\$${items[index].item_price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                trailing: Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        tooltip: 'Edit Price',
                        icon: const Icon(Icons.attach_money),
                        onPressed: () {
                          //_menu_info.removeAt(index);
                          editPrice(items, items[index].menu_item_id, index);
                        },
                      ),
                      type == 'smoothie' ? IconButton(
                        tooltip: 'Edit Ingredients',
                        icon: const Icon(Icons.edit),
                        onPressed: () {

                        },
                      ) : Container(),
                      IconButton(
                        tooltip: 'Remove from Menu',
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          confirmRemoval(items, items[index].menu_item,
                              items[index].menu_item_id, index);
                        }
                      ),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  void newItemSubWin(String item_type,)
  {
    TextEditingController _new_item_name = TextEditingController();
    TextEditingController _new_item_price = TextEditingController();
    TextEditingController _new_item_amount = TextEditingController();
    Icon message_icon = const Icon(Icons.check);
    String message_text = 'Successfully Added Item';

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New $item_type Creation'),
          content: SizedBox(
            width: 300,
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _new_item_name,
                  decoration: const InputDecoration(hintText: 'Name...'),
                ),
                TextFormField(
                  controller: _new_item_price,
                  decoration: const InputDecoration(hintText: 'Price...'),
                ),
                TextFormField(
                  controller: _new_item_amount,
                  decoration: const InputDecoration(hintText: 'Amount in Stock...'),
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
                  menu_item_obj new_item = menu_item_obj(0,
                      _new_item_name.text,
                      double.parse(double.parse(_new_item_price.text).toStringAsFixed(2)),
                      int.parse(_new_item_amount.text),
                      item_type == 'Snack' ? 'snack' : 'addon',
                      'available', []
                  );
                  item_helper.add_menu_item(new_item);
                  new_item.menu_item_id = await view_helper().get_item_id(_new_item_name.text);
                  if (item_type == 'Snack')
                    {
                      _snack_items.add(new_item);
                    }
                  if (item_type == 'Addon')
                  {
                    _addon_items.add(new_item);
                  }
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

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                if (title == 'Manage Smoothies')
                  {
                    title = 'Manage Addons';
                    setState(() {
                      visibility_ctrl = 2;
                    });
                  }
                else if (title == 'Manage Addons')
                {
                  title = 'Manage Snacks';
                  setState(() {
                    visibility_ctrl = 1;
                  });
                }
                else if (title == 'Manage Snacks')
                {
                  title = 'Manage Smoothies';
                  setState(() {
                    visibility_ctrl = 0;
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: TextStyle(fontSize: 35),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () {
                if (title == 'Manage Smoothies')
                {
                  title = 'Manage Snacks';
                  setState(() {
                    visibility_ctrl = 1;
                  });
                }
                else if (title == 'Manage Snacks')
                {
                  title = 'Manage Addons';
                  setState(() {
                    visibility_ctrl = 2;
                  });
                }
                else if (title == 'Manage Addons')
                {
                  title = 'Manage Smoothies';
                  setState(() {
                    visibility_ctrl = 0;
                  });
                }
              },
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: _isLoading ? const Center(
        child: CircularProgressIndicator() ,
          ) : Padding(
              padding: const EdgeInsets.only(bottom: 125),
              child: Stack(
                children: [
                    Visibility(
                      visible: visibility_ctrl == 0,
                      child: itemTable(_smoothie_items, 'smoothie'),
                    ),
                  Visibility(
                    visible: visibility_ctrl == 1,
                      child: itemTable(_snack_items, 'snack'),
                  ),
                  Visibility(
                      visible: visibility_ctrl == 2,
                      child: itemTable(_addon_items, 'addon')
                  ),
                  ],

              ),
            ),
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
            Login_Button(
              onTap: () {
                newItemSubWin('Snack');
              },
              buttonWidth: 200,
              buttonName: 'Add Snack',
            ),
            Login_Button(
              onTap: () {
                newItemSubWin('Addon');
              },
              buttonWidth: 200,
              buttonName: 'Add Addon',
            ),
          ],
        ),
      ),
    );
  }
}
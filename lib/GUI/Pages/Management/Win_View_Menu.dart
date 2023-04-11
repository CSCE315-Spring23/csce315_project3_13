import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_Add_Smoothie.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';
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
  final List<Map<String, String>> _menu_info = [];
  int visibility_ctrl = 0;
  String title = 'Manage Smoothies';
  bool _isLoading = true;
  List<menu_item_obj> _menu_items = [];
  menu_item_helper item_helper = menu_item_helper();
  TextEditingController new_price = TextEditingController();

  void getData() async {
    _menu_items = await item_helper.getAllSmoothiesInfo();
    int i=0;
    for (menu_item_obj smoothie in _menu_items)
      {
        i++;
        final new_row = {
          'id' : smoothie.menu_item_id.toString(),
          'name' : smoothie.menu_item,
          'price' : smoothie.item_price.toStringAsFixed(2),
        };
        setState(() {
          _menu_info.add(new_row);
        });
      }
    setState(() {
      _isLoading = false;
    });
  }

  void editPrice(int id, int index) {
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
                    _menu_items[index].item_price  = double.parse(new_price.text);
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
  void confirmRemoval(String item_name, int id, int index)
  {
    showDialog(
      context: context,
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
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  //  await item_helper.delete_menu_item(id);
                /*  setState(() {
                    _menu_items.removeAt(index);
                  });*/
                }
                catch (exception){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Icon(Icons.error_outline_sharp),
                          content: const Text('Unable to delete this item.'),
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
          ],),
        centerTitle: true,
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator() ,
          ) : Padding(
              padding: const EdgeInsets.only(bottom: 125),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _menu_items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child:  ListTile(
                      minVerticalPadding: 5,
                      onTap: () {},
                      leading: SizedBox(
                        width: 300,
                        child: Text(
                          _menu_items[index].menu_item_id.toString(),
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
                          _menu_items[index].menu_item,
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
                        '\$${_menu_items[index].item_price.toStringAsFixed(2)}',
                        style: TextStyle(
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
                                editPrice(_menu_items[index].menu_item_id, index);
                              },
                            ),
                            IconButton(
                              tooltip: 'Edit Ingredients',
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                //_menu_info.removeAt(index);
                              },
                            ),
                            IconButton(
                              tooltip: 'Remove from Menu',
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                confirmRemoval(_menu_items[index].menu_item,_menu_items[index].menu_item_id, index);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  );
                }),
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
            )
          ],
        ),
      ),
    );
  }
}
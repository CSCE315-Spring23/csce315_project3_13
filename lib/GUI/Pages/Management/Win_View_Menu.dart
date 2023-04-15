import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_Add_Smoothie.dart';
import 'package:csce315_project3_13/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/Services/general_helper.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';
import 'package:csce315_project3_13/Services/view_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Colors/Color_Manager.dart';
import '../../../Models/models_library.dart';
import 'package:flutter/material.dart';
import '../../Components/Page_Header.dart';

class Win_View_Menu extends StatefulWidget {
  static const String route = '/view-menu-manager';
  const Win_View_Menu({Key? key}) : super(key: key);

  @override
  State<Win_View_Menu> createState() => _Win_View_Menu_State();
}


class _Win_View_Menu_State extends State<Win_View_Menu>
{
  int visibility_ctrl = 0;
  String title = 'Manage Smoothies';
  bool _isLoading = true;
  List<menu_item_obj> _smoothie_items = [];
  List<menu_item_obj> _snack_items = [];
  List<menu_item_obj> _addon_items = [];
  menu_item_helper item_helper = menu_item_helper();
  TextEditingController new_price = TextEditingController();

  void getData() async
  {
    print('Building Page...');
    _smoothie_items = await item_helper.getAllSmoothiesInfo();
    print('Obtained Smoothies...');
    _snack_items = await item_helper.getAllSnackInfo();
    _addon_items = await item_helper.getAllAddonInfo();

    setState(()
    {
      _isLoading = false;
    });
  }

  void editPrice(List<menu_item_obj> items, int id, int index)
  {
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

  // - Widget that returns a list of cards that display item info and allow for
  //   item editing
  Widget itemList(List<menu_item_obj> items, String type, Color tile_color, Color _text_color, Color _icon_color)
  {
    return ListView.builder
      (
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
              child:  ListTile(
                tileColor: tile_color.withOpacity(0.75),
                minVerticalPadding: 5,
                onTap: () {},
                leading: SizedBox(
                  width: 300,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // TODO: (Stretch) Add icons to each type of menu item
       /*               if (type == 'smoothie')
                        Icon(Icons.local_cafe)
                      else if (type == 'snack')
                        Icon(Icons.local_dining)
                      else if (type == 'addon')
                          const Icon(Icons.add_circle_outline_sharp),
                      const SizedBox(width: 20,),
         */             Text(
                        'Item ID: ${items[index].menu_item_id.toString()}',
                        style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: _text_color.withOpacity(0.35),
                        ),
                      ),
                    ]
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    items[index].menu_item,
                    style: TextStyle(
                      color: _text_color.withOpacity(0.75),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                subtitle: Text(
                  '\$${items[index].item_price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    color: _text_color.withOpacity(0.50),
                  ),
                  textAlign: TextAlign.center,
                ),
                trailing: SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        tooltip: 'Edit Price',
                        icon: const Icon(Icons.attach_money),
                        color: _text_color.withOpacity(0.50),
                        onPressed: () {
                          //_menu_info.removeAt(index);
                          editPrice(items, items[index].menu_item_id, index);
                        },
                        iconSize: 35,
                      ),
                      type == 'smoothie' ? IconButton(
                        tooltip: 'Edit Ingredients',
                        icon: const Icon(Icons.edit),
                        color: _text_color.withOpacity(0.50),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/edit-smoothie-manager',
                            arguments:  {'name': items[index].menu_item,
                              'id': items[index].menu_item_id.toString()},
                          );
                        },
                        iconSize: 35,
                      ) : Container(),
                      IconButton(
                        tooltip: 'Remove from Menu',
                        icon: const Icon(Icons.delete),
                        color: _text_color.withOpacity(0.50),
                        iconSize: 35,
                        onPressed: () {
                          confirmRemoval(items, items[index].menu_item,
                              items[index].menu_item_id, index);
                        },
                      ),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  // Pop-up menu that allows for both new snack and addon creation
  void newItemSubWin(String item_type)
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

  // Tab Widget that allows for different menu displays
  Widget tab(Function tabChange, String tab_text, Color backgroundColor, Color headColor, int tab_ctrl)
  {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        minimumSize: MaterialStateProperty.all(Size(100, 65)),
        backgroundColor: MaterialStateProperty.all<Color>(visibility_ctrl == tab_ctrl ? backgroundColor: headColor),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
      ),
      onPressed: (){
        setState(() {
          if (tab_text == 'Manage Smoothies')
          {
            visibility_ctrl = 0;
          }
          else if (tab_text == 'Manage Snacks')
          {
            visibility_ctrl = 1;
          }
          else if (tab_text == 'Manage Addons')
          {
            visibility_ctrl = 2;
          }
        });
      }, child: Text(tab_text, style: const TextStyle(fontSize: 20),),
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
        pageName: "Menu Item Management",
        buttons: [
          tab((){}, 'Manage Smoothies', _color_manager.background_color, _color_manager.primary_color, 0),
          tab((){}, 'Manage Snacks', _color_manager.background_color, _color_manager.primary_color, 1),
          tab((){}, 'Manage Addons', _color_manager.background_color, _color_manager.primary_color, 2),
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
                      child: itemList(_smoothie_items, 'smoothie', _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
                    ),
                  Visibility(
                    visible: visibility_ctrl == 1,
                      child: itemList(_snack_items, 'snack', _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
                  ),
                  Visibility(
                      visible: visibility_ctrl == 2,
                      child: itemList(_addon_items, 'addon', _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
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
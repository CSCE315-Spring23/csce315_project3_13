/// Window for viewing an editable inventory.

import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/WIn_Edit_Smoothie.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_Add_Smoothie.dart';
import 'package:csce315_project3_13/GUI/Pages/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';
import 'package:csce315_project3_13/Services/view_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Inherited_Widgets/Color_Manager.dart';
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

  // GOOGLE TRANSLATE VARIABLES BEGIN

  google_translate_API _google_translate_api = google_translate_API();
  String _current_lang = "";

  List<String> build_texts_original = [
    "Manage Smoothies",
    "Edit Item Price",
    "New Price",
    "CANCEL",
    "CONFIRM",
    "Unable to change price for this item",
    "Successfully Removed Item",
    "Confirm Item Deletion",
    "Are you sure you want to delete",
    "Unable to remove item",
    "Item ID",
    "Edit Ingredients",
    "Remove from Menu",
    "Successfully Added Item",
    "New",
    "Creation",
    "Name",
    "Price",
    "Amount in Stock",
    "Add item",
    "Unable to add item",
    "Menu Item Management",
    "Return to Manager View",
    "Add Smoothie",
    "Add Snack",
    "Add Addon",
    "Manage Smoothies",
    "Manage Snacks",
    "Manage Addons",
  ];
  List<String> build_texts = [
    "Manage Smoothies",
    "Edit Item Price",
    "New Price",
    "CANCEL",
    "CONFIRM",
    "Unable to change price for this item",
    "Successfully Removed Item",
    "Confirm Item Deletion",
    "Are you sure you want to delete",
    "Unable to remove item",
    "Item ID",
    "Edit Ingredients",
    "Remove from Menu",
    "Successfully Added Item",
    "New",
    "Creation",
    "Name",
    "Price",
    "Amount in Stock",
    "Add item",
    "Unable to add item",
    "Menu Item Management",
    "Return to Manager View",
    "Add Smoothie",
    "Add Snack",
    "Add Addon",
  "Manage Smoothies",
  "Manage Snacks",
  "Manage Addons",
  ];

  String title = "Manage Smoothies";
  String text_edit_price = "Edit Item Price";
  String text_new_price = "New Price";
  String text_cancel_button = "CANCEL";
  String text_confirm_button = "CONFIRM";
  String text_unable_change_price = "Unable to change price for this item";
  String text_success_rem_item = "Successfully Removed Item";
  String text_confirm_item_del = "Confirm Item Deletion";
  String text_sure_del = "Are you sure you want to delete";
  String text_unable_rem_item = "Unable to remove item";
  String text_item_id = "Item ID";
  String text_edit_ingredients = "Edit Ingredients";
  String rem_from_menu = "Remove from Menu";
  String success_add_item = "Successfully Added Item";
  String text_new = "New";
  String text_creation = "Creation";
  String text_name = "Name";
  String text_price = "Price";
  String text_amount_in_stock = "Amount in Stock";
  String text_add_item = "Add item";
  String text_unable_add_item = "Unable to add item";
  String text_menu_item_man = "Menu Item Management";
  String text_ret_man_view = "Return to Manager View";
  String text_add_smoothie = "Add Smoothie";
  String text_add_snack = "Add Snack";
  String text_add_addon = "Add Addon";
  String text_manage_smoothies = "Manage Smoothies";
  String text_manage_snacks = "Manage Snacks";
  String text_manage_addons = "Manage Addons";



  List<String> smoothie_names = [];
  List<String> snack_names = [];
  List<String> addon_names = [];

  // GOOGLE TRANSLATE VARIABLES END

  bool first_load = false;





  int visibility_ctrl = 0;

  bool _isLoading = true;
  List<menu_item_obj> _smoothie_items = [];
  List<menu_item_obj> _snack_items = [];
  List<menu_item_obj> _addon_items = [];
  menu_item_helper item_helper = menu_item_helper();
  TextEditingController new_price = TextEditingController();

  // - Calls appropriate firebase function
  // - Displays a loading screen in the meantime
  Future<void> getData() async
  {
    print('Building Page...');
    _smoothie_items = await item_helper.getAllSmoothiesInfo();
    print('Obtained Smoothies...');
    _snack_items = await item_helper.getAllSnackInfo();
    _addon_items = await item_helper.getAllAddonInfo();

    for(int i = 0; i < _smoothie_items.length; i++){
      smoothie_names.add(_smoothie_items[i].menu_item);
    }

    for(int i = 0; i < _snack_items.length; i++){
      snack_names.add(_snack_items[i].menu_item);
    }

    for(int i = 0; i < _addon_items.length; i++){
      addon_names.add(_addon_items[i].menu_item);
    }

  }

  // Popup that handle price editing
  void editPrice(List<menu_item_obj> items, int id, int index)
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text_edit_price),
          content: TextFormField(
            controller: new_price,
            decoration: InputDecoration(hintText: text_new_price + "..."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(text_cancel_button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(text_confirm_button),
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
                          content: Text(text_unable_change_price),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text(text_confirm_button))
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


  // Popup that handle removal process
  void confirmRemoval(List<menu_item_obj> items, String item_name, int id, int index)
  {
    Icon message_icon = const Icon(Icons.check);
    String message_text = text_success_rem_item;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text_confirm_item_del),
          content: Text(
               text_sure_del + ' $item_name ?'
          ),
          actions: <Widget>[
            TextButton(
              child: Text(text_cancel_button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(text_confirm_button),
              onPressed: () async {
                try {
                  await item_helper.delete_menu_item(id);
                  setState(() {
                    items.removeAt(index);
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(Win_View_Menu.route);
                }
                catch(exception)
                {
                  print(exception);
                  message_icon = const Icon(Icons.error_outline_outlined);
                  message_text = text_unable_rem_item;
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
                                child: Text(text_confirm_button))
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
                tileColor: tile_color.withAlpha(200),
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
                        text_item_id + ': ${items[index].menu_item_id.toString()}',
                        style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: _text_color.withAlpha(75),
                        ),
                      ),
                    ]
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    type == "smoothie"?  smoothie_names[index] : type == "snack"?  snack_names[index] : type == "addon"?  addon_names[index] :   items[index].menu_item ,
                    // items[index].menu_item,
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
                  '\$${items[index].item_price.toStringAsFixed(2)}',
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
                        tooltip: text_edit_price,
                        icon: const Icon(Icons.attach_money),
                        color: _text_color.withAlpha(122),
                        onPressed: () {
                          //_menu_info.removeAt(index);
                          editPrice(items, items[index].menu_item_id, index);
                        },
                        iconSize: 35,
                      ),
                      type == 'smoothie' ? IconButton(
                        tooltip: text_edit_ingredients,
                        icon: const Icon(Icons.edit),
                        color: _text_color.withAlpha(122),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            Win_Edit_Smoothie.route,
                            arguments:  {'name': items[index].menu_item,
                              'id': items[index].menu_item_id.toString()},
                          );
                        },
                        iconSize: 35,
                      ) : Container(),
                      IconButton(
                        tooltip: rem_from_menu,
                        icon: const Icon(Icons.delete),
                        color: _text_color.withAlpha(122),
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

  // Pop-up that allows for both new snack and addon creation
  void newItemSubWin(String item_type)
  {
    TextEditingController _new_item_name = TextEditingController();
    TextEditingController _new_item_price = TextEditingController();
    TextEditingController _new_item_amount = TextEditingController();
    Icon message_icon = const Icon(Icons.check);
    String message_text = success_add_item;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text( text_new + ' $item_type ' + text_creation),
          content: SizedBox(
            width: 300,
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _new_item_name,
                  decoration:  InputDecoration(
                    hintText:  text_name + '...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _new_item_price,
                  decoration:  InputDecoration(hintText: text_price + '...'),
                ),
                TextFormField(
                  controller: _new_item_amount,
                  decoration: InputDecoration(hintText: text_amount_in_stock + '...'),
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
              child: Text(text_add_item),
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
                  message_text = text_unable_add_item;
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
                                child:Text(text_confirm_button))
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
          if (tab_text == text_manage_smoothies)
          {
            visibility_ctrl = 0;
          }
          else if (tab_text == text_manage_snacks)
          {
            visibility_ctrl = 1;
          }
          else if (tab_text == text_manage_addons)
          {
            visibility_ctrl = 2;
          }
        });
      }, child: Text(tab_text, style: const TextStyle(fontSize: 20),),
    );
  }

  @override
  void initState() {
    // getData(true);
    first_load = true;

    super.initState();
  }


  @override
  Widget build(BuildContext context){
    final _color_manager = Color_Manager.of(context);


    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {

      build_texts = (await _google_translate_api.translate_batch(build_texts_original,_translate_manager.chosen_language));

      title = build_texts[0];
      text_edit_price = build_texts[1];
      text_new_price = build_texts[2];
      text_cancel_button = build_texts[3];
      text_confirm_button = build_texts[4];
      text_unable_change_price = build_texts[5];
      text_success_rem_item = build_texts[6];
      text_confirm_item_del = build_texts[7];
      text_sure_del = build_texts[8];
      text_unable_rem_item = build_texts[9];
      text_item_id = build_texts[10];
      text_edit_ingredients = build_texts[11];
      rem_from_menu = build_texts[12];
      success_add_item = build_texts[13];
      text_new = build_texts[14];
      text_creation = build_texts[15];
      text_name = build_texts[16];
      text_price = build_texts[17];
      text_amount_in_stock = build_texts[18];
      text_add_item = build_texts[19];
      text_unable_add_item = build_texts[20];
      text_menu_item_man = build_texts[21];
      text_ret_man_view = build_texts[22];
      text_add_smoothie = build_texts[23];
      text_add_snack = build_texts[24];
      text_add_addon = build_texts[25];
      text_manage_smoothies = build_texts[26];
      text_manage_snacks = build_texts[27];
      text_manage_addons = build_texts[28];

      _current_lang = _translate_manager.chosen_language;
      await getData();



      smoothie_names = (await _google_translate_api.translate_batch(smoothie_names,_translate_manager.chosen_language));

      snack_names = (await _google_translate_api.translate_batch(snack_names,_translate_manager.chosen_language));

      addon_names = (await _google_translate_api.translate_batch(addon_names,_translate_manager.chosen_language));


      first_load = false;
      setState(()
      {
        _isLoading = false;
      });
    }

    if ((!_isLoading) && (_current_lang != _translate_manager.chosen_language)) {
      setState(() {
        _isLoading = true;
      });
    }

    if (((_isLoading && (_current_lang != _translate_manager.chosen_language))) || first_load) {
      set_translation();
    }










    return Scaffold(
      appBar: Page_Header(
        showWeather: false,
        context: context,
        pageName: text_menu_item_man,
        buttons: [
          tab((){}, text_manage_smoothies, _color_manager.background_color, _color_manager.primary_color, 0),
          tab((){}, text_manage_snacks, _color_manager.background_color, _color_manager.primary_color, 1),
          tab((){}, text_manage_addons, _color_manager.background_color, _color_manager.primary_color, 2),
          IconButton(
            tooltip: text_ret_man_view,
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
                      child: itemList(_smoothie_items, "smoothie", _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
                    ),
                  Visibility(
                    visible: visibility_ctrl == 1,
                      child: itemList(_snack_items, "snack", _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
                  ),
                  Visibility(
                      visible: visibility_ctrl == 2,
                      child: itemList(_addon_items, "addon", _color_manager.secondary_color, _color_manager.text_color, _color_manager.active_color),
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
                buttonName: text_add_smoothie,
            ),
            Login_Button(
              onTap: () {
                newItemSubWin('Snack');
              },
              buttonWidth: 200,
              buttonName: text_add_snack,
            ),
            Login_Button(
              onTap: () {
                newItemSubWin('Addon');
              },
              buttonWidth: 200,
              buttonName: text_add_addon,
            ),
          ],
        ),
      ),
    );
  }
}
/// Window for adding a new smoothie.

import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:csce315_project3_13/Services/ingredients_table_helper.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Models/models_library.dart';
import 'package:flutter/material.dart';
import '../../Components/Page_Header.dart';

class Win_Add_Smoothie extends StatefulWidget {
  static const String route = '/add-smoothie-manager';
  const Win_Add_Smoothie({Key? key}) : super(key: key);
  
  @override
  State<Win_Add_Smoothie> createState() => _Win_Add_Smoothie_State();
}

class _Win_Add_Smoothie_State extends State<Win_Add_Smoothie>
{

  // GOOGLE TRANSLATE VARIABLES BEGIN
  google_translate_API _google_translate_api = google_translate_API();
  String _current_lang = "";

  List<String> build_texts_original = [
   'Index',
  'Name',
  'Delete',
   "Add New Ingredient",
  "Create New Smoothie",
   "Return to Menu Management",
  'Successfully Added Item',
   'Unable to add item',
   "Accept",
    'Add New Item',
    "Ingredients",
   'New Ingredient',
  'CANCEL',
   "ADD",
   "New Smoothie Name",
  "Price of Medium",
  "Amount in Stock",
  ];
  List<String> build_texts = [
    'Index',
    'Name',
    'Delete',
    "Add New Ingredient",
    "Create New Smoothie",
    "Return to Menu Management",
    'Successfully Added Item',
    'Unable to add item',
    "Accept",
    'Add New Item',
    "Ingredients",
    'New Ingredient',
    'CANCEL',
    "ADD",
    "New Smoothie Name",
    "Price of Medium",
    "Amount in Stock",
  ];

  List<String> _ing_names_translated = [];

  String text_data_col_index = 'Index';
  String text_data_col_name = 'Name';
  String text_data_col_delete = 'Delete';
  String text_add_new_ingredient = "Add New Ingredient";
  String text_page_name = "Create New Smoothie";
  String text_ret_menu_management = "Return to Menu Management";
  String text_successfully_added = 'Successfully Added Item';
  String text_unable_add = 'Unable to add item';
  String text_accept_button = "Accept";
  String text_add_new_item = 'Add New Item';
  String text_ingredient =  "Ingredients";
  String text_new_ingredient = 'New Ingredient';
  String text_cancel_button = 'CANCEL';
  String text_add_button = "ADD";
  String text_new_smoothie_name = "New Smoothie Name";
  String text_price_of_medium = "Price of Medium";
  String text_amount_in_stock = "Amount in Stock";


  bool first_load = false;


  // GOOGLE TRANSLATE VARIABLES END



  // data displayed on table
  List<Map<String, String>> _ing_table = [];

  // Ingredient names displayed on buttons
  List<String> _ing_names = [];

  // Use for firebase calls
  ingredients_table_helper ing_helper = ingredients_table_helper();

  bool _isLoading = true;
  double screenWidth =  0;

  // Textfield Controller
  final TextEditingController _new_ingredient = TextEditingController();
  final TextEditingController _new_price_ctrl = TextEditingController();
  final TextEditingController _new_name_ctrl = TextEditingController();
  final TextEditingController _new_amount_ctrl = TextEditingController();

  // New Item Attributes
  String _new_ingredient_name = '';
  String _new_item_name = '';
  double _new_item_price = 0;
  int _new_item_amount = 0;

  // - Calls appropriate firebase function
  // - Displays a loading screen in the meantime
  Future<void> getNames() async {
    // Simulate fetching data from an API
    _ing_names = await ing_helper.get_all_ingredient_names();
    setState(() {
      _isLoading = false;
    });
  }


  // Returns a button grid for with each button allowing for an ingredient addition
  Widget buttonGrid(BuildContext context, Color _button_color)
  {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      padding: const EdgeInsets.all(10),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: _ing_names.map((name) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(_button_color),
          minimumSize: MaterialStateProperty.all(const Size(125, 50)),
        ),
        onPressed: () {
          setState(() {
            _ing_table.add({'index': (_ing_table.length + 1).toString(), 'name': name});
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                _ing_names.indexOf(name) != -1? _ing_names_translated[_ing_names.indexOf(name)] : name,
               // name,
              style: const TextStyle(fontSize: 20,),
              textAlign: TextAlign.center,
              maxLines: 2, // Limits the number of lines to 2
              overflow: TextOverflow.ellipsis, // Truncates the text with "..." if it overflows
            ),
          ],
        ),
      )).toList(),
    );

  }

  // Creates a dataTable that will display ingredient additions
  Widget ingTable(BuildContext context, Color text_color)
  {
    return Container(
      alignment: Alignment.topCenter,
      child: ListView(
        shrinkWrap: true,
        children: [
          DataTable(
            headingTextStyle: TextStyle(
              color: text_color.withAlpha(220),
              fontWeight: FontWeight.bold,
            ),
            dataTextStyle: TextStyle(
              color: text_color.withAlpha(200),
            ),
            columnSpacing: 10,
            columns: [
              DataColumn(label: Text(text_data_col_index),),
              DataColumn(label: Text(text_data_col_name),),
              DataColumn(label: Text(text_data_col_delete)),
            ],
            rows: _ing_table.map((rowData) {
              final rowIndex = _ing_table.indexOf(rowData);
              return DataRow(cells: [
                DataCell(Text('${rowData['index']}')),
                // _ing_names.indexOf(rowData['name'] as String) != -1? _ing_names_translated[_ing_names.indexOf(rowData['name'] as String)] : rowData['name'] as String,
                DataCell(Text('${_ing_names.indexOf(rowData['name'] as String) != -1? _ing_names_translated[_ing_names.indexOf(rowData['name'] as String)] : rowData['name'] as String}')),
                // DataCell(Text('${rowData['name']}')),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete, color: text_color.withAlpha(150),),
                    onPressed: () {
                      setState(() {
                        _ing_table.removeAt(rowIndex);
                        for (int i = rowIndex; i < _ing_table.length; i++) {
                          _ing_table[i]['index'] = (i + 1).toString();
                        }
                      });
                    },
                  ),
                ),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Returns a Textfield widget with custom decoration
  Widget custTextfield(BuildContext context, TextEditingController ctrl, String text_deco, String buttonText)
  {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: text_deco == text_add_new_ingredient + '...' ? 75 : 45,
            width: text_deco == text_add_new_ingredient + '...' ? screenWidth / 5 : screenWidth / 7,
            child: TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: text_deco,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (text) {
                setState(() {
                  if (text_deco ==  text_add_new_ingredient + '...')
                  {
                    _new_ingredient_name = ctrl.text;
                  }
                  else if (text_deco == text_new_smoothie_name + '... ')
                  {
                    _new_item_name = ctrl.text;
                  }
                    else if (text_deco == text_price_of_medium + '...')
                    {
                    _new_item_price = double.parse(ctrl.text);
                    }
                    else if (text_deco == text_amount_in_stock+ '...')
                    {
                    _new_item_amount = int.parse(ctrl.text);
                    }

                });
              },
            ),
          ),
          const SizedBox(width: 10,),
        ],
      );
  }

  @override
  void initState() {
    first_load = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    final _color_manager = Color_Manager.of(context);



    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {

      build_texts = (await _google_translate_api.translate_batch(build_texts_original,_translate_manager.chosen_language));
      text_data_col_index = build_texts[0];
      text_data_col_name = build_texts[1];
      text_data_col_delete = build_texts[2];
      text_add_new_ingredient = build_texts[3];
      text_page_name = build_texts[4];
      text_ret_menu_management = build_texts[5];
      text_successfully_added = build_texts[6];
      text_unable_add = build_texts[7];
      text_accept_button = build_texts[8];
      text_add_new_item = build_texts[9];
      text_ingredient =  build_texts[10];
      text_new_ingredient = build_texts[11];
      text_cancel_button = build_texts[12];
      text_add_button = build_texts[13];
      text_new_smoothie_name = build_texts[14];
      text_price_of_medium = build_texts[15];
      text_amount_in_stock = build_texts[16];


      _current_lang = _translate_manager.chosen_language;
      await getNames();



      _ing_names_translated = (await _google_translate_api.translate_batch(_ing_names,_translate_manager.chosen_language));



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



    screenWidth = MediaQuery.of(context).size.width;
    getNames();
    return Scaffold(
      appBar: Page_Header(
        // showWeather: false,
        context: context,
        pageName: text_page_name,
        buttons: [
          IconButton(
            tooltip: text_ret_menu_management,
            padding: const EdgeInsets.only(left: 25, right: 10),
            onPressed: ()
            {
              Navigator.pushReplacementNamed(context,Win_View_Menu.route);
            },
            icon: const Icon(Icons.close_rounded),
            iconSize: 40,
          ),
        ],
      ),
   backgroundColor: _color_manager.background_color,
   body: _isLoading
          ? Center(
          child: SpinKitRing(color: _color_manager.primary_color),
         )
        : Column(
          children: [
            Flexible(
              child: Row(
              children: <Widget>[
                Container(
                  color: _color_manager.secondary_color.withAlpha(50),
                  width: screenWidth / 2,
                  child: Column(
                    children: [
                      Expanded(flex: 1, child: ingTable(context, _color_manager.text_color)),
                      SizedBox(
                        height: 175,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                            color: _color_manager.background_color.withAlpha(120),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  custTextfield(context, _new_name_ctrl, text_new_smoothie_name + '... ', ''),
                                  const SizedBox(width: 10,),
                                  custTextfield(context, _new_price_ctrl, text_price_of_medium + '...', ''),
                                  const SizedBox(width: 10,),
                                  custTextfield(context, _new_amount_ctrl, text_amount_in_stock+ '...', ''),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              SizedBox(
                                width: (screenWidth / 2) - (screenWidth / 10),
                                height: 50,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(_color_manager.active_confirm_color.withAlpha(200)),
                                    ),

                                    // Handling of firebase error when adding new smoothie
                                    onPressed: () async
                                    {
                                      Icon message_icon = const Icon(Icons.check);
                                      String message_text = text_successfully_added;
                                      List<String> new_item_ings = [];
                                      for (int i = 0; i < _ing_table.length; ++i)
                                        {
                                          new_item_ings.add(_ing_table[i]['name']!);
                                        }
                                      if (_new_item_name != '' && new_item_ings.length != 0 && _new_item_price != 0){
                                        try {
                                          menu_item_obj new_item = menu_item_obj(
                                              0,
                                              _new_item_name,
                                              double.parse(_new_item_price.toStringAsFixed(2)),
                                              _new_item_amount,
                                              'smoothie',
                                              'available',
                                              new_item_ings);
                                          await menu_item_helper().add_menu_item(
                                              new_item);
                                        }

                                        catch(exception)
                                      {
                                        print(exception);
                                        message_icon = const Icon(Icons.error_outline_outlined);
                                        message_text = text_unable_add;
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
                                                      child: Text(text_accept_button))
                                                ],
                                              );
                                            });
                                      }
                                      }
                                },
                                    child: Text(
                                      text_add_new_item,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth / 2,
                  color: _color_manager.background_color.withAlpha(200),
                  child: Column(
                    children: [
                      Container(
                        height: 75,
                        color: _color_manager.secondary_color.withAlpha(75),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                               text_ingredient,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: _color_manager.text_color.withAlpha(200),
                                ),
                              ),
                              IconButton(
                                  tooltip: text_add_new_ingredient,
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  onPressed: ()
                                  {
                                    TextEditingController _new_ingredient = TextEditingController();

                                    // Popup that allows for new ingredient additions through a textbox
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(text_new_ingredient),
                                          content: SizedBox(
                                            width: (screenWidth / 5) + 10,
                                            height: 45,
                                            child: custTextfield(context, _new_ingredient , text_add_new_ingredient + '...', text_add_new_ingredient),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(text_cancel_button),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                                onPressed: ()
                                                {
                                                  _ing_table.add({'index': (_ing_table.length + 1).toString(), 'name': _new_ingredient_name});
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(text_add_button))
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon:  Icon(
                                      Icons.add_circle,
                                      color: _color_manager.text_color.withAlpha(200),
                                  )
                              )
                            ],
                          ),

                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: buttonGrid(context, _color_manager.active_color)),
                    ],
                  ),
                )
              ],),
            ),
          ],
        ),
    );
  }
}


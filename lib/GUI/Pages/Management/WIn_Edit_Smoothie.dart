import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:csce315_project3_13/Services/ingredients_table_helper.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Inherited_Widgets/Color_Manager.dart';
import 'package:flutter/material.dart';
import '../../../Services/general_helper.dart';
import '../../Components/Page_Header.dart';

class Win_Edit_Smoothie extends StatefulWidget {
  static const String route = '/edit-smoothie-manager';
  const Win_Edit_Smoothie({Key? key}) : super(key: key);

  @override
  State<Win_Edit_Smoothie> createState() => _Win_Edit_Smoothie_State();
}

class _Win_Edit_Smoothie_State extends State<Win_Edit_Smoothie> with AutomaticKeepAliveClientMixin {

  // GOOGLE TRANSLATE VARIABLES BEGIN

  google_translate_API _google_translate_api = google_translate_API();
  String _current_lang = "";

  List<String> build_texts_original = [
  'Index',
  'Name',
  'Amount',
  'Delete',
  "Currently Editing",
  "Return to Menu Management",
  'Successfully Edited Item',
  "Unable to edit item",
  'Confirm',
  'Confirm Edits',
  'Available Ingredients',
  ];
  List<String> build_texts = [
    'Index',
    'Name',
    'Amount',
    'Delete',
    "Currently Editing",
    "Return to Menu Management",
    'Successfully Edited Item',
    "Unable to edit item",
    'Confirm',
    'Confirm Edits',
    'Available Ingredients',
  ];

  String text_data_col_index = 'Index';
  String text_data_col_name = 'Name';
  String text_data_col_amount = 'Amount';
  String text_data_col_delete = 'Delete';
  String text_currently_editing = "Currently Editing";
  String text_ret_menu_man = "Return to Menu Management";
  String text_success_edit = 'Successfully Edited Item';
  String text_unable_edit = 'Unable to edit item';
  String text_confirm_button = 'Confirm';
  String text_confirm_edits =  'Confirm Edits';
  String text_available_ingred =  'Available Ingredients';
  List<String> _ing_names_translated = [];

  bool first_load = false;



  // GOOGLE TRANSLATE VARIABLES END


  List<Map<String, String>> _ing_table = [];
  List<String> _ing_names = [];
  Map<String, int> _curr_ings = {};
  ingredients_table_helper ing_helper = ingredients_table_helper();
  bool _isLoading = true;
  bool _add_curr_ings = false;
  bool _adding_item = false;
  double screenWidth =  0;
  String _curr_item_name = "";
  int _curr_item_id = 0;


  // - Calls appropriate firebase function
  // - Populates table with current smoothie ingredients
  // - Displays a loading screen in the meantime
  Future<void> getData() async {
    // Simulate fetching data from an API
    _ing_names = await ing_helper.get_all_ingredient_names();
    if (!mounted) {
      return;
    }

    if (!_add_curr_ings) {
      _curr_ings =
      await general_helper().get_smoothie_ingredients(_curr_item_id);

      _curr_ings.forEach((key, value) {
        _ing_table.add({
          'index': (_ing_table.length + 1).toString(),
          'name': key,
          'amount': value.toString()
        });
      }
      );
      _add_curr_ings = true;
    }

  }

  // Returns a button grid for with each button allowing for an ingredient addition
  Widget buttonGrid(BuildContext context,Color _button_color)
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
          bool is_in_table = false;
          for (Map<String, String> item in _ing_table)
            {
              if (item['name'] == name)
                {
                  setState(() {
                    _ing_table[int.parse(item['index']!) - 1]['amount'] =
                        (int.parse(_ing_table[int.parse(item['index']!) - 1]['amount']!) + 1).toString();
                    is_in_table = true;
                  });
                }
            }
          if (!is_in_table){
            setState(() {
              _ing_table.add({'index': (_ing_table.length + 1).toString(), 'name': name, 'amount' : 1.toString()});
            });
          }
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
              DataColumn(label: Text(text_data_col_amount)),
              DataColumn(label: Text(text_data_col_delete)),
            ],
            rows: _ing_table.map((rowData) {
              final rowIndex = _ing_table.indexOf(rowData);
              return DataRow(cells: [
                DataCell(Text('${rowData['index']}')),
                DataCell(Text('${_ing_names.indexOf(rowData['name'] as String) != -1? _ing_names_translated[_ing_names.indexOf(rowData['name'] as String)] : rowData['name']}')),
                // DataCell(Text('${rowData['name']}')),
                DataCell(Text('${rowData['amount']}')),
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

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    first_load = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    super.build(context);
    final args = ModalRoute.of(context)!.settings.arguments;
    // check if argument are null, in the case of a reload
    if (args != null)
      {
        Map<String, String> curr_item = args as Map<String, String>;
        _curr_item_name = curr_item['name']!;
        _curr_item_id = int.parse(curr_item['id']!);
      }
    else{_add_curr_ings = true;}
    getData();
    screenWidth = MediaQuery.of(context).size.width;
    final _color_manager = Color_Manager.of(context);


    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {

      build_texts = (await _google_translate_api.translate_batch(build_texts_original,_translate_manager.chosen_language));
      text_data_col_index = build_texts[0];
      text_data_col_name = build_texts[1];
      text_data_col_amount = build_texts[2];
      text_data_col_delete = build_texts[3];
      text_currently_editing = build_texts[4];
      text_ret_menu_man = build_texts[5];
      text_success_edit = build_texts[6];
      text_unable_edit = build_texts[7];
      text_confirm_button = build_texts[8];
      text_confirm_edits =  build_texts[9];
      text_available_ingred = build_texts[10];


      _current_lang = _translate_manager.chosen_language;
      await getData();



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


    return Scaffold(
      appBar: Page_Header(
        showWeather: false,
        context: context,
        pageName:  text_currently_editing + ": $_curr_item_name",
        buttons: [
          IconButton(
            tooltip: text_ret_menu_man,
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
      body: _isLoading
          ? Center(
        child: SpinKitRing(color: _color_manager.primary_color),
      )
          : Row(
        children: <Widget>[
          Container(
            color: _color_manager.secondary_color.withAlpha(100),
            width: screenWidth / 2,
            child: Column(
              children: [
                Expanded(flex: 1, child: ingTable(context, _color_manager.text_color)),
                Container(
                  height: 125,
                  width: screenWidth / 2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 0.25,
                    ),
                    color: Colors.white38,
                  ),
                  child: ElevatedButton(
                    // Call firebase function and display appropriate info
                    onPressed: args != null && !_adding_item ? () async{
                        Icon message_icon = const Icon(Icons.check);
                        String message_text = text_success_edit;
                        Map<String, int> new_item_ings = {};
                        for (int i = 0; i < _ing_table.length; ++i)
                        {
                          new_item_ings[_ing_table[i]['name']!] = int.parse(_ing_table[i]['amount']!);
                        }
                        if (new_item_ings.length != 0){
                          try {
                            setState(() {
                              _adding_item = true;
                            });
                            await menu_item_helper().edit_smoothie_ingredients(_curr_item_id, new_item_ings);
                            setState(() {
                              _adding_item = false;
                            });
                          }
                          catch(exception)
                          {
                            print(exception);
                            message_icon = const Icon(Icons.error_outline_outlined);
                            message_text = text_unable_edit;
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
                          }
                        }
                      } : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(_color_manager.active_confirm_color.withAlpha(200)),
                      ),
                      child: Text(
                       text_confirm_edits,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth / 2,
            color: _color_manager.background_color.withAlpha(220),
            child: Column(
              children: [
                Container(
                  height: 75,
                  color: _color_manager.secondary_color.withAlpha(175),
                  child: Center(
                    child: Text(
                      text_available_ingred,
                      style: TextStyle(color: Colors.white, fontSize: 30),),),
                ),
                Expanded(
                    flex: 1,
                    child: buttonGrid(context, _color_manager.active_color)),
              ],
            ),
          )
        ],
      ),
    );
  }
}


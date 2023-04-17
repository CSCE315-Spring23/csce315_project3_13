import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
import 'package:csce315_project3_13/Services/ingredients_table_helper.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../Colors/Color_Manager.dart';
import '../../../Models/models_library.dart';
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
  List<Map<String, String>> _ing_table = [];
  List<String> _ing_names = [];
  Map<String, int> _curr_ings = {};
  ingredients_table_helper ing_helper = ingredients_table_helper();
  bool _isLoading = true;
  bool _add_curr_ings = false;
  bool _adding_item = false;
  double screenWidth =  0;
  String _curr_item_name = '';
  int _curr_item_id = 0;

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

    setState(() {
      _isLoading = false;
    });
  }

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
              name,
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
            columns: const [
              DataColumn(label: Text('Index'),),
              DataColumn(label: Text('Name'),),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Delete')),
            ],
            rows: _ing_table.map((rowData) {
              final rowIndex = _ing_table.indexOf(rowData);
              return DataRow(cells: [
                DataCell(Text('${rowData['index']}')),
                DataCell(Text('${rowData['name']}')),
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
    return Scaffold(
      appBar: Page_Header(
        context: context,
        pageName: "Currently Editing: $_curr_item_name",
        buttons: [
          IconButton(
            tooltip: "Return to Menu Management",
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
                      onPressed: args != null && !_adding_item ? () async{
                        Icon message_icon = const Icon(Icons.check);
                        String message_text = 'Successfully Edited Item';
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
                            message_text = 'Unable to edit item';
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
                          }
                        }
                      } : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(_color_manager.active_confirm_color.withAlpha(200)),
                      ),
                      child: const Text(
                        'Confirm Edits',
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
                  child: const Center(
                    child: Text(
                      'Available Ingredients',
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


import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
import 'package:csce315_project3_13/Services/ingredients_table_helper.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';

import '../../../Models/models_library.dart';
import 'package:flutter/material.dart';

import '../../../Services/general_helper.dart';

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

  Widget buttonGrid(BuildContext context)
  {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      padding: const EdgeInsets.all(10),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: _ing_names.map((name) => ElevatedButton(
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
              style: const TextStyle(fontSize: 12,),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )).toList(),
    );

  }

  Widget ingTable(BuildContext context)
  {
    return Container(
      alignment: Alignment.topCenter,
      child: ListView(
        shrinkWrap: true,
        children: [
          DataTable(
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
                    icon: const Icon(Icons.delete),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context,Win_View_Menu.route);
          },
        ),
        title: Text("Currently Editing: $_curr_item_name"),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Row(
        children: <Widget>[
          Container(
            width: screenWidth / 2,
            child: Column(
              children: [
                Expanded(flex: 1, child: ingTable(context)),
                SizedBox(
                  height: 125,
                  width: screenWidth / 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.25,
                      ),
                      color: Colors.white38,
                    ),
                    child: ElevatedButton(
                        onPressed: args != null ? () async{
                          Icon message_icon = const Icon(Icons.check);
                          String message_text = 'Successfully Edited Item';
                          List<String> new_item_ings = [];
                          for (int i = 0; i < _ing_table.length; ++i)
                          {
                            new_item_ings.add(_ing_table[i]['name']!);
                          }
                          if (new_item_ings.length != 0){
                            try {

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
                        child: const Text('Add New Item')
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth / 2,
            color: const Color.fromRGBO(255, 204, 204, 1),
            child: Column(
              children: [
                Container(
                  height: 50,
                  color: Colors.pink,
                  child: Center(
                    child: Text(
                      'Available Ingredients',
                      style: TextStyle(color: Colors.white, fontSize: 30),),),
                ),
                Expanded(
                    flex: 1,
                    child: buttonGrid(context)),
              ],
            ),
          )
        ],
      ),
    );
  }
}


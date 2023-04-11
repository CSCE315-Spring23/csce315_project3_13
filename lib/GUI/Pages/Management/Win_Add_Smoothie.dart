import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
import 'package:csce315_project3_13/Services/ingredients_table_helper.dart';
import 'package:csce315_project3_13/Services/menu_item_helper.dart';

import '../../../Models/models_library.dart';
import 'package:flutter/material.dart';

class Win_Add_Smoothie extends StatefulWidget {
  static const String route = '/add-smoothie-manager';
  const Win_Add_Smoothie({Key? key}) : super(key: key);

  @override
  State<Win_Add_Smoothie> createState() => _Win_Add_Smoothie_State();
}

class _Win_Add_Smoothie_State extends State<Win_Add_Smoothie> {
  List<Map<String, String>> _ing_table = [];
  List<String> _ing_names = [];
  ingredients_table_helper ing_helper = ingredients_table_helper();
  bool _isLoading = true;
  double screenWidth =  0;
  final TextEditingController _new_ingredient = TextEditingController();
  final TextEditingController _new_price_ctrl = TextEditingController();
  final TextEditingController _new_name_ctrl = TextEditingController();
  final TextEditingController _new_amount_ctrl = TextEditingController();
  String _new_ingredient_name = '';
  String _new_item_name = '';
  double _new_item_price = 0;
  int _new_item_amount = 0;

  Future<void> getNames() async {
    // Simulate fetching data from an API
    _ing_names = await ing_helper.get_all_ingredient_names();
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
          setState(() {
            _ing_table.add({'index': (_ing_table.length + 1).toString(), 'name': name});
          });
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
              DataColumn(label: Text('Delete')),
            ],
            rows: _ing_table.map((rowData) {
              final rowIndex = _ing_table.indexOf(rowData);
              return DataRow(cells: [
                DataCell(Text('${rowData['index']}')),
                DataCell(Text('${rowData['name']}')),
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

  Widget custTextfield(BuildContext context, TextEditingController ctrl, String text_deco, String buttonText)
  {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: text_deco == 'Add New Ingredient...' ? 75 : 45,
            width: text_deco == 'Add New Ingredient...' ? screenWidth / 5 : screenWidth / 7,
            child: TextField(
              controller: ctrl,
              decoration: InputDecoration(
                  hintText: text_deco,
              ),
              onChanged: (text) {
                setState(() {
                  if (text_deco == 'Add New Ingredient...')
                  {
                    _new_ingredient_name = ctrl.text;
                  }
                  else if (text_deco == 'New Smoothie Name... ')
                  {
                    _new_item_name = ctrl.text;
                  }
                    else if (text_deco == 'Price of Medium...')
                    {
                    _new_item_price = double.parse(ctrl.text);
                    }
                    else if (text_deco == 'Amount in Stock...')
                    {
                    _new_item_amount = int.parse(ctrl.text);
                    }

                });
              },
            ),
          ),
          const SizedBox(width: 10,),
          (text_deco == 'Add New Ingredient...') ?
          ElevatedButton(
            child: Text(
              buttonText,
            ),
            onPressed: () {
              if (text_deco == 'Add New Ingredient...')
                {
                  _ing_table.add({'index': (_ing_table.length + 1).toString(), 'name': _new_ingredient_name});
                }
            },
          ) : Container(),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    getNames();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context,Win_View_Menu.route);
            },
        ),
        title: const Text("Create New Smoothie"),
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
                  height: 175,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                      color: Colors.white38,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            custTextfield(context, _new_name_ctrl, 'New Smoothie Name... ', ''),
                            SizedBox(width: 10,),
                            custTextfield(context, _new_price_ctrl, 'Price of Medium...', ''),
                            SizedBox(width: 10,),
                            custTextfield(context, _new_amount_ctrl, 'Amount in Stock...', ''),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        ElevatedButton(
                            onPressed: () async{
                              Icon message_icon = const Icon(Icons.check);
                              String message_text = 'Successfully Added Item';
                              List<String> new_item_ings = [];
                              for (int i = 0; i < _ing_table.length; ++i)
                                {
                                  new_item_ings.add(_ing_table[i]['name']!);
                                }
                              if (_new_item_name != '' && new_item_ings.length != 0 && _new_item_price != 0){
                                try {
                                  print(_new_item_price.toStringAsFixed(2));
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
                              }
                              }
                        },
                            child: const Text('Add New Item')),
                      ],
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
                  height: 100,
                  child: Center(
                    child: custTextfield(context, _new_ingredient , 'Add New Ingredient...', 'Add Ingredient'),
                  ),
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


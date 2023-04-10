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
            width: screenWidth / 5,
            child: TextField(
              controller: ctrl,
              decoration: InputDecoration(
                  hintText: text_deco,
              ),
              onChanged: (text) {
                setState(() {
                  if (text_deco == 'Add New Ingredient...')
                  {
                    _new_ingredient_name = text;
                  }
                  else if (text_deco == 'New Smoothie Name... ')
                  {
                    _new_item_name = text;
                  }
                  else if (text_deco == 'New Smoothie Price of Medium...')
                  {
                    _new_item_price = double.parse(text);
                  }
                  else if (text_deco == 'New Smoothie Amount in Stock...')
                  {
                    _new_item_amount = int.parse(text);
                  }

                });
              },
            ),
          ),
          SizedBox(width: 10,),
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
        title: Text("Create New Smoothie"),
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
            color: Colors.blue,
            child: Column(
              children: [
                Expanded(flex: 1, child: ingTable(context)),
                SizedBox(
                  height: 175,
                  child: Container(
                    color: Colors.yellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            custTextfield(context, _new_name_ctrl, 'New Smoothie Name... ', ''),
                            SizedBox(height: 5,),
                            custTextfield(context, _new_price_ctrl, 'New Smoothie Price of Medium...', ''),
                            SizedBox(height: 5,),
                            custTextfield(context, _new_amount_ctrl, 'New Smoothie Amount in Stock...', ''),
                          ],
                        ),
                        SizedBox(width: 20,),
                        ElevatedButton(onPressed: (){
                          List<String> new_item_ings = [];
                          for (int i = 0; i < _ing_table.length; ++i)
                            {
                              new_item_ings.add(_ing_table[i]['name']!);
                            }
                          if (_new_item_name == '' || _new_item_amount == 0 || new_item_ings.length != 0){
                            menu_item_obj new_item = menu_item_obj(0, _new_item_name, _new_item_price, _new_item_amount, 'Smoothie', 'available', new_item_ings);
                            menu_item_helper().add_menu_item(new_item);
                          }
                        }, child: Text('Add New Item')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth / 2,
            color: Colors.purple,
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


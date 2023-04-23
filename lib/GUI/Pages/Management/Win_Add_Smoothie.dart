import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
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
            height: text_deco == 'Add New Ingredient...' ? 75 : 45,
            width: text_deco == 'Add New Ingredient...' ? screenWidth / 5 : screenWidth / 7,
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
        ],
      );
  }

  @override
  Widget build(BuildContext context)
  {
    final _color_manager = Color_Manager.of(context);
    screenWidth = MediaQuery.of(context).size.width;
    getNames();
    return Scaffold(
      appBar: Page_Header(
        context: context,
        pageName: "Create New Smoothie",
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
                                  custTextfield(context, _new_name_ctrl, 'New Smoothie Name... ', ''),
                                  const SizedBox(width: 10,),
                                  custTextfield(context, _new_price_ctrl, 'Price of Medium...', ''),
                                  const SizedBox(width: 10,),
                                  custTextfield(context, _new_amount_ctrl, 'Amount in Stock...', ''),
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
                                      String message_text = 'Successfully Added Item';
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
                                        message_text = 'Unable to add item';
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
                                },
                                    child: const Text(
                                      'Add New Item',
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
                                "Ingredients",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: _color_manager.text_color.withAlpha(200),
                                ),
                              ),
                              IconButton(
                                  tooltip: "Add new ingredient",
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
                                          title: const Text('New Ingredient'),
                                          content: SizedBox(
                                            width: (screenWidth / 5) + 10,
                                            height: 45,
                                            child: custTextfield(context, _new_ingredient , 'Add New Ingredient...', 'Add Ingredient'),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('CANCEL'),
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
                                                child: Text("ADD"))
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


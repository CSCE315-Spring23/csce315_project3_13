import 'package:csce315_project3_13/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/Models/Order%20Models/addon_order.dart';
import 'package:csce315_project3_13/Models/Order%20Models/curr_order.dart';
import 'package:csce315_project3_13/Models/Order%20Models/smoothie_order.dart';
import 'package:csce315_project3_13/Models/Order%20Models/snack_order.dart';
import 'package:csce315_project3_13/Services/order_processing_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../Colors/Color_Manager.dart';
import '../../../Services/menu_item_helper.dart';
import '../../../Services/view_helper.dart';
import '../../Components/Page_Header.dart';
import '../Login/Win_Login.dart';
import '../Loading/Loading_Order_Win.dart';
import '../../../Models/models_library.dart';

class Win_Order extends StatefulWidget {
  static const String route = '/order';

  @override
  State<Win_Order> createState() => Win_Order_State();
}

class Win_Order_State extends State<Win_Order>{

  // Todo: get smoothie names from database
  List<String> _smoothie_names = [];
  // Todo: get snack names from database
  List<String> _snack_names = [];
  // Todo" get addon names from database
  List<String> _addon_names = [];

  List<menu_item_obj> _all_menu_items = [];

  // controls visibility between smoothies and snacks menu
  int _activeMenu = 0;

  //control visibility of addons menu
  int _activeMenu2 = 0;

  // controls visibility of table (order or addon)
  int _active_table = 0;


  menu_item_helper item_helper = menu_item_helper();

  TextEditingController customer = TextEditingController();
  String _curr_customer = 'None';
  smoothie_order _curr_smoothie = smoothie_order(smoothie: 'ERROR', Size: 'ERROR', price: 0, table_index: 0);
  curr_order _current_order = curr_order();
  bool _curr_editing = false;

  // data displayed on tables
  final List<Map<String, String>> _orderTable = [];
  final List<Map<String, String>> _addonTable = [];

  bool _isLoading = true;

  // Used to prevent errors
  menu_item_obj _blank_item = menu_item_obj(0, "", 0, 0, "", "", []);

  Future<void> getData() async {
    // Simulate fetching data from an API
    view_helper name_helper = view_helper();
    _smoothie_names = await name_helper.get_unique_smoothie_names();
    _snack_names = await name_helper.get_snack_names();
    _addon_names =  await name_helper.get_addon_names();
    _all_menu_items = await item_helper.getAllSmoothiesInfo();
    _all_menu_items.addAll(await item_helper.getAllSnackInfo());
    _all_menu_items.addAll(await item_helper.getAllAddonInfo());
    for (menu_item_obj item in _all_menu_items)
      {
        print(item.menu_item);
      }
    setState(() {
      _isLoading = false;
    });
  }

  // adds row to order table
  _addToOrder(String item, String size, String type) {
    String item_name = size != "-" ? "$item $size" : item;
    String price = _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == (item_name)).item_price.toStringAsFixed(2);

    if (type == 'Smoothie'){
      setState(() {
        _curr_smoothie.setSmoothiePrice(double.parse(price));
        price = _curr_smoothie.getCost().toStringAsFixed(2);
        _current_order.addSmoothie(_curr_smoothie);
      });
    }
    else if (type == 'Snack'){
      snack_order snack = snack_order(
        name: item,
        price: double.parse(price),
        table_index: _orderTable.length + 1,
      );
      setState(() {
        _current_order.addSnack(snack);
      });
    }
    final newRow = {
      'index': (_orderTable.length + 1).toString(),
      'name': item,
      'size': size,
      'price': price,
    };
    setState(() {
      if (!_curr_editing || _orderTable.isEmpty) {
        _orderTable.add(newRow);
      }
      else{
        _orderTable.insert(_curr_smoothie.table_index - 1, newRow);
      }
    });
    _curr_editing = false;
  }

  // add addon to addon table
  void _addAddon(String item) {
    String price = _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == (item)).item_price.toStringAsFixed(2);
    final newRow = {
      'index': (_addonTable.length + 1).toString(),
      'name': item,
      'price': price,
    };
    addon_order new_addon = addon_order(name: item, price: double.parse(price), amount: 1);
    setState(() {
      // limit addons to 8
      if (_addonTable.length < 8) {
        _curr_smoothie.addAddon(new_addon);
        _addonTable.add(newRow);
      }
    });
  }

  // creates a popup asking for user info (currently, just the name)
  void customerInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Customer Information'),
          content: TextFormField(
            controller: customer,
            decoration: const InputDecoration(hintText: 'Type here...'),
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
              onPressed: () {
                setState(() {
                  _curr_customer = customer.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget tab(String tab_text, Color backgroundColor, int tab_ctrl)
  {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        minimumSize: MaterialStateProperty.all(const Size(100, 65)),
        backgroundColor: MaterialStateProperty.all<Color>(_activeMenu == tab_ctrl ? backgroundColor : backgroundColor.withAlpha(100)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
      ),
      onPressed: _activeMenu != tab_ctrl ?  (){
        setState(() {
          if (tab_text == 'Smoothies')
          {
            _activeMenu = 0;
          }
          else if (tab_text == 'Snacks')
          {
            _activeMenu = 1;
          }
        });
      } : null, child: Text(tab_text, style: const TextStyle(fontSize: 20),),
    );
  }

  Widget buttonGrid(BuildContext context, List<String> button_names, String type, Color _button_color){
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      padding: const EdgeInsets.all(10),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: button_names.map((name) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(_button_color),
          minimumSize: MaterialStateProperty.all(const Size(125, 50)),
        ),
        onPressed: () {
          if (type == "Smoothie" ) {
            setState(() {
              _curr_smoothie = smoothie_order(smoothie: name,
                Size: 'medium', price: 0,
                table_index: _orderTable.length + 1,
              );
              _activeMenu2 = 1;
              _active_table = 1;
            });
          }
          if (type == 'Snack') {
            setState(() {
              _addToOrder(name, '-', 'Snack');
            });
          }
          if (type == 'Addon'){
            setState(() {
              _addAddon(name);
            });
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 15,),
                  textAlign: TextAlign.center,
                  maxLines: 3, // Limits the number of lines to 2
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: type != "Smoothie" ? Text(
                _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == (name)).item_price.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white24),
              ): Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                    _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ("$name small"), orElse: () {return _blank_item;},).item_price.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white24),
                    ),
                    Text(
                      _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ("$name medium"), orElse: () {return _blank_item;}).item_price.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.white24),
                    ),
                    Text(
                      _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ("$name large"), orElse: () {return _blank_item;}).item_price.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.white24),
                    ),
                  ]
              ),
            ),
          ],
        ),
      )).toList(),
    );

  }

  Future<List<int>> getIds() async{
    List<smoothie_order> smoothies= _current_order.getSmoothies();
    List<snack_order> snacks = _current_order.getSnacks();
    List<int> item_ids = [];
    view_helper helper_instance = view_helper();

    for (snack_order snack in snacks)
    {
      int snack_id = await helper_instance.get_item_id(snack.name);
      item_ids.add(snack_id);
    }
    for (smoothie_order smoothie in smoothies)
    {
      int smooth_id = await helper_instance.get_item_id(smoothie.getSmoothie());
      item_ids.add(smooth_id);
      List<addon_order> addons = smoothie.getAddons();
      for (addon_order addon in addons)
      {
        int addon_id = await helper_instance.get_item_id(addon.name);
        item_ids.add(addon_id);
      }
    }
    return item_ids;
  }

  void process_order() async {
    // if nothing in order, then don't process
    if ((_current_order.getSnacks().length == 0) && (_current_order.getSmoothies() == 0))
    {
      return;
    }
    List<int> item_ids_in_order = await getIds();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    order_processing_helper order_helper = order_processing_helper();
    int trans_id = await order_helper.get_new_transaction_id();
    order_obj order_to_process = order_obj(trans_id, 3, item_ids_in_order, _current_order.price , _curr_customer, formattedDate, 'completed');
    order_helper.process_order(order_to_process);
    _current_order.clear();
    _orderTable.clear();
    _addonTable.clear();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);
    return Scaffold(
      // TODO: Add smoothie king icon to page header
        appBar: Page_Header(
          context: context,
          pageName: "Smoothie King at the MSC",
          buttons: [
            IconButton(
              tooltip: "Return to Manager View",
              padding: const EdgeInsets.only(left: 25, right: 10),
              onPressed: ()
              {
                Navigator.pushReplacementNamed(context,Win_Manager_View.route);
              },
              icon: const Icon(Icons.close_rounded),
              iconSize: 40,
            ),
          ],
        ),
        backgroundColor: _color_manager.background_color,
        body: _isLoading ? const Center(
          child: SpinKitCircle(color: Colors.redAccent,),
        ) : Row(
          children: <Widget>[
            Expanded(
              child:  Container(
                color: _color_manager.background_color.withAlpha(100),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        // Order table
                        Visibility(
                          visible: _active_table == 0,
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                DataTable(
                                  columnSpacing: 0,
                                  columns: const [
                                    DataColumn(label: Text('Index'),),
                                    DataColumn(label: Text('Name'),),
                                    DataColumn(label: Text('Size')),
                                    DataColumn(label: Text('Price')),
                                    DataColumn(label: Text('Edit')),
                                    DataColumn(label: Text('Delete')),
                                  ],
                                  rows: _orderTable.map((rowData) {
                                    final rowIndex = _orderTable.indexOf(rowData);
                                    return DataRow(cells: [
                                      DataCell(Text('${rowData['index']}')),
                                      DataCell(Text('${rowData['name']}')),
                                      DataCell(Text('${rowData['size']}')),
                                      DataCell(Text('${rowData['price']}')),
                                      DataCell(
                                        rowData['size'] != '-' ? IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            if (rowData['size'] != '-') {
                                              setState(() {
                                                Map<String,
                                                    dynamic> item = _orderTable
                                                    .elementAt(rowIndex);
                                                _orderTable.removeAt(rowIndex);
                                                _curr_smoothie =
                                                    _current_order.remove(
                                                        int.parse(item['index']));
                                                _active_table = 1;
                                                _activeMenu2 = 1;
                                                _addonTable.clear();
                                                for (addon_order addon in _curr_smoothie
                                                    .getAddons()) {
                                                  final newRow = {
                                                    'index': (_addonTable.length + 1).toString(),
                                                    'name': addon.name,
                                                    'price': addon.price.toStringAsFixed(2),
                                                  };
                                                  _addonTable.add(newRow);
                                                }
                                                _curr_editing = true;
                                              });
                                            }
                                          },
                                        ) : Container(),
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              Map<String, dynamic> item = _orderTable.elementAt(rowIndex);
                                              // Todo: find a more efficient way to change indexes
                                              _current_order.remove(int.parse(item['index']));
                                              _orderTable.removeAt(rowIndex);
                                              _current_order.reorderIndexes(rowIndex + 1);
                                              for (int i = rowIndex; i < _orderTable.length; i++) {
                                                _orderTable[i]['index'] = (i + 1).toString();
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
                          ),
                        ),
                        // Addon table, appears when adding or editing smoothie in order
                        Visibility(
                          visible: _active_table == 1,
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                DataTable(
                                  columnSpacing: 0,
                                  columns: const [
                                    DataColumn(label: Text('Index'),),
                                    DataColumn(label: Text('Name'),),
                                    DataColumn(label: Text('Price')),
                                    DataColumn(label: Text('Delete')),
                                  ],
                                  rows: _addonTable.map((rowData) {
                                    final rowIndex = _addonTable.indexOf(rowData);
                                    return DataRow(cells: [
                                      // Todo: add amount column
                                      DataCell(Text('${rowData['index']}')),
                                      DataCell(Text('${rowData['name']}')),
                                      DataCell(Text('${rowData['price']}')),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              _addonTable.removeAt(rowIndex);
                                              _curr_smoothie.removeAddon(rowIndex);
                                              for (int i = rowIndex; i < _addonTable.length; i++) {
                                                _addonTable[i]['index'] = (i + 1).toString();
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
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox(height: 1,),),
                    SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                customerInfo();
                              },
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 75,
                                  ),
                                  Text(
                                    '$_curr_customer',
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Total: ${_current_order.price.toStringAsFixed(2)}',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, Win_Manager_View.route);
                              },
                              child: const Icon(
                                Icons.logout,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _current_order.clear();
                                  _orderTable.clear();
                                });
                              },
                              child: const Icon(
                                Icons.cancel_outlined,
                              ),
                            ),
                          ),
                          // Todo: Process order
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                if (!_curr_editing) {
                                  process_order();
                                }
                              },
                              child: const Icon(
                                Icons.monetization_on,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Navigation between smoothie and snack button grids
            Expanded(
              child: Stack(
                children: <Widget>[
                  Visibility(
                    visible: _activeMenu2 == 0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: tab("Smoothies", _color_manager.background_color, 0),
                              ),
                              Expanded(
                                child: tab("Snacks", _color_manager.background_color, 1),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              // smoothie button grid
                              Visibility(
                                visible: _activeMenu == 0,
                                child: Scrollbar(
                                  thickness: 30,
                                  interactive: true,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    primary: true,
                                    child: Container(
                                      child: buttonGrid(context, _smoothie_names, "Smoothie", _color_manager.active_color),
                                    ),
                                  ),
                                ),
                              ),

                              // snack button grid
                              Visibility(
                                visible: _activeMenu == 1,
                                child: Scrollbar(
                                  thickness: 30,
                                  interactive: true,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    primary: true,
                                    child: Container(
                                      child: buttonGrid(context, _snack_names, "Snack", _color_manager.active_color.withRed(25).withGreen(180)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _activeMenu2 == 1,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        // if currently editing smoothie, insert it to previous index
                                        if (_curr_editing)
                                        {
                                          _addToOrder(_curr_smoothie.getSmoothie(), _curr_smoothie.getSize(), 'Smoothie');
                                        }

                                        _activeMenu2 = 0;
                                        _active_table = 0;
                                        _addonTable.clear();
                                      });
                                    },
                                    child: const Icon(Icons.arrow_back),
                                  ),
                                ),
                              ),

                              // widget used to cycle through smoothie sizes
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: (){
                                          setState(() {
                                            if (_curr_smoothie.getSize() == 'medium'){
                                              _curr_smoothie.setSmoothieSize('large');
                                            }
                                            else if (_curr_smoothie.getSize() == 'small'){
                                              _curr_smoothie.setSmoothieSize('medium');
                                            }
                                            else if (_curr_smoothie.getSize() == 'large'){
                                              _curr_smoothie.setSmoothieSize('small');
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.arrow_drop_up)
                                    ),
                                    Text(
                                      _curr_smoothie.getSmoothie(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: (){
                                          setState(() {
                                            if (_curr_smoothie.getSize() == 'medium'){
                                              _curr_smoothie.setSmoothieSize('small');
                                            }
                                            else if (_curr_smoothie.getSize() == 'small'){
                                              _curr_smoothie.setSmoothieSize('large');
                                            }
                                            else if (_curr_smoothie.getSize() == 'large'){
                                              _curr_smoothie.setSmoothieSize('medium');
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.arrow_drop_down)
                                    ),
                                  ],
                                ),
                              ),

                              // Adds smoothie with addons to order
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                                  child: !_curr_editing ? ElevatedButton(
                                      onPressed: (){
                                        setState(() {
                                          _addToOrder(
                                            _curr_smoothie.getSmoothie(),
                                            _curr_smoothie.getSize(),
                                            'Smoothie',
                                          );
                                          _activeMenu2 = 0;
                                          _active_table = 0;
                                          _addonTable.clear();
                                        });
                                      },
                                      child: const Text("Add to Order")
                                  ) : Container(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Addon table
                        Expanded(
                          child: Scrollbar(
                            thickness: 30,
                            interactive: true,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              primary: true,
                              child: Container(
                                  child: buttonGrid(context, _addon_names, 'Addon', _color_manager.active_color.withBlue(255))
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
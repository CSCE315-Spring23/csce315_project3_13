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
  List<menu_item_obj> _smoothie_items = [];
  List<menu_item_obj> _snack_items = [];
  List<menu_item_obj> _addon_items = [];

  // controls visibility between smoothies and snacks menu
  int _activeMenu = 0;

  //control visibility of addons menu
  int _activeMenu2 = 0;

  // controls visibility of table (order or addon)
  int _active_table = 0;

  // controls the smoothie category that is currently visible
  String _curr_category = "";

  menu_item_helper item_helper = menu_item_helper();

  TextEditingController customer = TextEditingController();
  String _curr_customer = 'None';
  curr_order _current_order = curr_order();
  bool _curr_editing = false;

  double screenWidth = 0;
  double screenHeight = 0;

  // data displayed on tables
  final List<Map<String, String>> _orderTable = [];
  final List<Map<String, String>> _addonTable = [];

  Map<String, String> smoothie_cats = {};


  List<String> category_names = [];

  bool _isLoading = true;


  //Todo: get rid of these once categories are implemented
  List<String> fitness_smoothies = [];
  List<String> energy_smoothies = [];
  List<String> weight_smoothies = [];
  List<String> well_smoothies = [];
  List<String> treat_smoothies = [];
  List<String> other_smoothies = [];

  // Used to prevent errors
  menu_item_obj _blank_item = menu_item_obj(0, "", 0, 0, "", "", []);
  smoothie_order _curr_smoothie = smoothie_order(smoothie: "Error", curr_size: "medium", curr_price: 0, table_index: -1);

  Future<void> getData() async
  {
    // Simulate fetching data from an API
    view_helper name_helper = view_helper();
    _smoothie_names = await name_helper.get_unique_smoothie_names();

    // TODO: add categories to database, delete this once implemented
    for (String name in _smoothie_names)
      {
        if (name.contains("Espresso") || name.contains("Recharge") || name.contains("Cold Brew"))
        {
        energy_smoothies.add(name);
        }
        else  if (name.contains("Activator") || name.contains("Gladiator")
            || name.contains("Hulk") || name.contains("High Intensity")
            || name.contains("High Protein") || (name.contains("Power") && name.contains("Plus")))
        {
          fitness_smoothies.add(name);
        }
        else if (name.contains("Keto") || name.contains("Lean1")
            || name.contains("MangoFest") || name.contains("Metabolism")
            || name.contains("Shredder") || name.contains("Slim-N-Trim"))
        {
          weight_smoothies.add(name);
        }
        else if (name.contains("Kale") || name.contains("Heaven")
            || name.contains("Collagen") || name.contains("Daily Warrior")
            || name.contains("Gut Health") || name.contains("Greek Yogurt")
            || name.contains("Immune Builder") || name.contains("Power Meal")
            || name.contains("Spinach") || name.contains("Vegan"))
        {
          well_smoothies.add(name);
        }
        else if (name.contains("Angel") || name.contains("Treat")
            || name.contains("Boat") || name.contains("Twist")
            || name.contains("Punch") || name.contains("Way")
            || name.contains("Tango") || name.contains("Impact")
            || name.contains("Punch") || name.contains("Passport")
            || name.contains("Surf") || name.contains("Breeze")
            || name.contains("X-treme") || name.contains("D-Lite")
            || name.contains("Kindness"))
        {
          treat_smoothies.add(name);
        }
        else{
          other_smoothies.add(name);
        }

      }


    _smoothie_items = await item_helper.getAllSmoothiesInfo();
    _snack_items = await item_helper.getAllSnackInfo();
    _addon_items = await item_helper.getAllAddonInfo();

    for (menu_item_obj snack in _snack_items){_snack_names.add(snack.menu_item);}
    for (menu_item_obj addon in _addon_items){_addon_names.add(addon.menu_item);}

    // TODO: get categories
    category_names = ["Feel Energized", "Get Fit", "Manage Weight", "Be Well", "Enjoy a Treat", "Special"];

    // TODO: remove the need for big list, by checking for type before calling
    _all_menu_items = _smoothie_items;
    _all_menu_items.addAll(_snack_items);
    _all_menu_items.addAll(_addon_items);
    setState(() {
      _isLoading = false;
    });
  }

  // adds row to order table
  _addToOrder(String item, String size, String type) {
    String item_name = size != "-" ? '$item $size' : item;
    String price = _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == (item_name)).item_price.toStringAsFixed(2);
    String size_abrv = (size != "-") ? (size == "small") ? "S" : (size == "medium") ? "M" : "L" : "-";

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
      'index': !_curr_editing ? (_orderTable.length + 1).toString() : _curr_smoothie.table_index.toString(),
      'name': item,
      'size': size_abrv,
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
      crossAxisCount: type != "Category" ? 4 : 2,
      childAspectRatio:type != "Category"? 1 : 2,
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
                curr_size: 'medium', curr_price: 0,
                table_index: _orderTable.length + 1,
              );
              _activeMenu2 = 1;
              _active_table = 1;
              _curr_category = "";
            });
          }
          else if (type == 'Snack') {
            setState(() {
              _addToOrder(name, '-', 'Snack');
            });
          }
          else if (type == 'Addon'){
            setState(() {
              _addAddon(name);
            });
          }
          else if (type == 'Category')
            {
              setState(() {
                _curr_category = name;
                _activeMenu2 = 2;
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
                  style: TextStyle(fontSize:type != "Category" ? 15 : 25,),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            type != "Category" ? Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: type != "Smoothie" ? Text(
                _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == (name)).item_price.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white24),
              ): Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ("$name small"), orElse: () {return _blank_item;},).item_price.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white24),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ("$name medium"), orElse: () {return _blank_item;}).item_price.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white24),
                        maxLines: 1, // Limits the number of lines to 2
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _all_menu_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ("$name large"), orElse: () {return _blank_item;}).item_price.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white24),
                        maxLines: 1, // Limits the number of lines to 2
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]
              ),
            ) : Container(),
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
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // TODO: Add smoothie king icon to page header
        appBar: Page_Header(
          context: context,
          pageName: "Smoothie King - MSC Texas A&M",
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
        // - set background color for loading screen as normal background color
        // - avoid using background color when loaded widget because it messes with alphas adjustments
        backgroundColor: _isLoading ? _color_manager.background_color : Colors.white,
        body: _isLoading ? const Center(
          child: SpinKitCircle(color: Colors.redAccent,),
        ) : Row(
          children: <Widget>[
            Container(
              width: screenWidth / 2,
              decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 2.5, color: _color_manager.text_color.withAlpha(122)),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: [
                        // Order table
                        Visibility(
                          visible: _activeMenu2 == 0,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              DataTable(
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
                                        onPressed: ()
                                        {
                                          if (rowData['size'] != '-')
                                          {
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
                                                  .getAddons())
                                              {
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
                        // Addon table, appears when adding or editing smoothie in order
                        Visibility(
                          visible: _active_table == 1,
                          child: Container(
                            alignment: Alignment.topCenter,
                            height: screenHeight - 75,
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
                     /*   Stack(
                          children: List.generate(
                            category_names.length,
                                (index) =>
                              buttonGrid(context, button_names, "Smoothie", _color_manager.active_color),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: (screenWidth / 4) - 2.5, // 2.5 accounts for border
                          color: _color_manager.background_color.withAlpha(120),
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
                                  _curr_customer,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth / 4,
                          color: _color_manager.background_color.withAlpha(50),
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
                        Container(
                          width: (screenWidth / 2) / 3,
                          color: _color_manager.active_deny_color.withAlpha(200),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, Win_Manager_View.route);
                            },
                            child: const Icon(
                              Icons.logout,
                            ),
                          ),
                        ),
                        Container(
                          width: ((screenWidth / 2) / 3) - 2.5,
                          color: _color_manager.active_deny_color.withAlpha(100),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
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
                        SizedBox(
                          width: (screenWidth / 2) / 3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(_color_manager.active_confirm_color.withAlpha(200)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
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

            // Second half of GUI
            Container(
              color: _color_manager.background_color,
              width: screenWidth / 2,
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
                              SizedBox(
                                width:screenWidth / 4 ,
                                child: tab("Smoothies", _color_manager.background_color, 0),
                              ),
                              SizedBox(
                                width:screenWidth / 4 ,
                                child: tab("Snacks", _color_manager.background_color, 1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight - 166,
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
                                      color: _color_manager.background_color,
                                      child: buttonGrid(context, category_names, "Category", _color_manager.active_color),
                                      // child: buttonGrid(context, _smoothie_names, "Smoothie", _color_manager.active_color),
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
                                      color: _color_manager.background_color,
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
                        Container(
                          color: _color_manager.primary_color.withAlpha(122),
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                width: (screenWidth / 2) / 6,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  child: !_curr_editing ? ElevatedButton(
                                    onPressed: (){
                                      setState(() {

                                        _activeMenu2 = 0;
                                        _active_table = 0;
                                        _addonTable.clear();
                                      });
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(_color_manager.active_deny_color),
                                    ),
                                    child: const Icon(Icons.arrow_back),
                                  ) : Container(),
                                ),
                              ),

                              // widget used to cycle through smoothie sizes
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: (screenWidth / 2) * (2/3),
                                    child: TextButton(
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
                                        child: Icon(
                                          Icons.arrow_drop_up,
                                          color: _color_manager.text_color,
                                        )
                                    ),
                                  ),
                                  Text(
                                    _curr_smoothie.getSmoothie(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: _color_manager.text_color.withAlpha(200),
                                      overflow: TextOverflow.ellipsis,
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
                                      child: Icon(
                                          Icons.arrow_drop_down,
                                        color: _color_manager.text_color,
                                      )
                                  ),
                                ],
                              ),
                              // Adds smoothie with addons to order
                              SizedBox(
                                width: (screenWidth/ 2) / 6,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: ElevatedButton(
                                      onPressed: (){
                                        setState(() {
                                          _addToOrder(
                                            _curr_smoothie.getName(),
                                            _curr_smoothie.getSize(),
                                            'Smoothie',
                                          );
                                          _activeMenu2 = 0;
                                          _active_table = 0;
                                          _addonTable.clear();
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(_color_manager.active_confirm_color.withAlpha(200)),
                                      ),
                                      child: Text(_curr_editing ? "Re-add to Order" : "Add to Order", textAlign: TextAlign.center,)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Addon table
                        Container(
                          width: screenWidth / 2,
                          height: screenHeight - 156,
                          color: _color_manager.background_color,
                          child: buttonGrid(context, _addon_names, 'Addon', _color_manager.active_color.withBlue(255)),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _curr_category != "",
                    child: Column(
                      children: [
                        Container(
                          color: _color_manager.primary_color.withAlpha(122),
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                width: (screenWidth / 2) / 6,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        _activeMenu2 = 0;
                                        _curr_category = "";
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(_color_manager.active_deny_color),
                                    ),
                                    child: const Icon(Icons.arrow_back),
                                  ),
                                ),
                              ),
                              // widget used to cycle through smoothie sizes
                              Expanded(
                                child: Center(
                                  child: Text(
                                    '$_curr_category Smoothies',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: _color_manager.text_color,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              // Adds smoothie with addons to order
                              SizedBox(
                                width: (screenWidth/ 2) / 6,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight - 166,
                          child: Stack(
                            children: <Widget>[
                              Visibility(
                                visible: _curr_category == "Get Fit",
                                child: buttonGrid(context, fitness_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Feel Energized",
                                child: buttonGrid(context, energy_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Manage Weight",
                                child: buttonGrid(context, weight_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Be Well",
                                child: buttonGrid(context, well_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Enjoy A Treat",
                                child: buttonGrid(context, treat_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Special",
                                child: buttonGrid(context, other_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                            ],
                          ),
                        )
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
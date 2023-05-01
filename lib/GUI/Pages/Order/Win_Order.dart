import 'package:csce315_project3_13/GUI/Pages/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/Models/Order%20Models/addon_order.dart';
import 'package:csce315_project3_13/Models/Order%20Models/curr_order.dart';
import 'package:csce315_project3_13/Models/Order%20Models/smoothie_order.dart';
import 'package:csce315_project3_13/Models/Order%20Models/snack_order.dart';
import 'package:csce315_project3_13/Services/order_processing_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Services/menu_item_helper.dart';
import '../../../Services/view_helper.dart';
import '../../Components/Page_Header.dart';
import '../Login/Win_Login.dart';
import '../../../Models/models_library.dart';

class Win_Order extends StatefulWidget {
  static const String route = '/order';

  @override
  State<Win_Order> createState() => Win_Order_State();
}

class Win_Order_State extends State<Win_Order>
{
  // GOOGLE TRANSLATE STRINGS START

  List<String> build_texts_originals = [
    "Smoothie King - Texas A&M MSC",
    "Return to Manager View",
    "Index",
    "Name",
    "Size",
    "Price",
    "Edit",
    "Delete",
    "Total",
    "Smoothies",
    "Snacks",
    "Category",
    "Snack",
    "Large",
    "Medium",
    "Small",
    "Addon",
    "Smoothie"
  ];

  List<String> build_texts = [
    "Smoothie King - Texas A&M MSC",
    "Return to Manager View",
    "Index",
    "Name",
    "Size",
    "Price",
    "Edit",
    "Delete",
    "Total",
    "Smoothies",
    "Snacks",
    "Category",
    "Snack",
    "Large",
    "Medium",
    "Small",
    "Addon",
    "Smoothie"
  ];


  //Strings for build
  String text_page_title =  "Smoothie King - Texas A&M MSC";
  String text_ret_prev_view = "Return to Manager View";
  String text_datacolumn_index = 'Index';
  String text_datacolumn_name = 'Name';
  String text_datacolumn_size = 'Size';
  String text_datacolumn_price = 'Price';
  String text_datacolumn_edit = 'Edit';
  String text_datacolumn_delete = 'Delete';
  String text_total = "Total";
  String text_smoothies_tab = "Smoothies";
  String text_snacks_tab = "Snacks";
  String text_category_tab = "Category";
  String text_snack_tab = "Snack";
  String text_large_label = "Large";
  String text_medium_label = "Medium";
  String text_small_label = "Small";
  String text_addon_tab = "Addon";
  String text_smoothie_tab = "Smoothie";



  // GOOGLE TRANSLATE STRINGS END




  List<String> _smoothie_names = [];
  List<String> _snack_names = [];
  List<String> _addon_names = [];

  // Database info
  List<menu_item_obj> _all_menu_items = [];
  List<menu_item_obj> _smoothie_items = [];
  List<menu_item_obj> _snack_items = [];
  List<menu_item_obj> _addon_items = [];
  List<String> category_names = [];


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

  // Tracks current order using menu item models
  curr_order _current_order = curr_order();

  // Tracks whether a smoothie is currently being edited
  bool _curr_editing = false;
  bool _order_processing = false;
  
  //smoothie_order _unedit_smooth = smoothie_order(smoothie: smoothie, curr_size: curr_size, curr_price: curr_price, table_index: table_index);

  // Smoothie selected for editing prior to editing

  // Current screen dimensions used to track
  double screenWidth = 0;
  double screenHeight = 0;

  // data displayed on tables
  final List<Map<String, String>> _orderTable = [];
  final List<Map<String, String>> _addonTable = [];

  Map<String, String> smoothie_cats = {};

  // Tracks whether firebase calls are active
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
    view_helper name_helper = view_helper();
  //  _smoothie_names = await name_helper.get_unique_smoothie_names();


    _smoothie_items = await item_helper.getAllSmoothiesInfo();
    _snack_items = await item_helper.getAllSnackInfo();
    _addon_items = await item_helper.getAllAddonInfo();

    String clipped_name = "";
    int unclipped_length = 0;
    for (int i = 0; i < _smoothie_items.length; i++) {
      if (_smoothie_items[i].menu_item.contains("small")) {
        unclipped_length = _smoothie_items[i].menu_item.length;
        clipped_name = _smoothie_items[i].menu_item.substring(0, unclipped_length - 6);
        _smoothie_names.add(clipped_name);
      }
    }

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

    for (menu_item_obj snack in _snack_items){_snack_names.add(snack.menu_item);}
    for (menu_item_obj addon in _addon_items){_addon_names.add(addon.menu_item);}

    // TODO: get categories
    category_names = ["Feel Energized", "Get Fit", "Manage Weight", "Be Well", "Enjoy a Treat", "Seasonal"];

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
    // TODO: Implement amounts
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
          title: const Text('Customer Name'),
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
          if (tab_text == text_smoothies_tab)
          {
            _activeMenu = 0;
          }
          else if (tab_text == text_snack_tab)
          {
            _activeMenu = 1;
          }
        });
      } : null,
      child: Text(
        tab_text,
        style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold),
            overflow: TextOverflow.fade
        ,),
    );
  }
  // Grid of Buttons used for selection of categories
  Widget buttonGrid(List<String> button_names, String type, Color _button_color){
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: type != text_category_tab ?  type != text_addon_tab ? 4 : 5 : 2,
      childAspectRatio:type != text_snack_tab? 1 : 2,
      padding: const EdgeInsets.all(10),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: button_names.map((name) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(_button_color),
          minimumSize: MaterialStateProperty.all(const Size(125, 50)),
        ),
        onPressed: () {
          if (type == text_smoothie_tab ) {
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
          else if (type == text_snack_tab) {
            setState(() {
              _addToOrder(name, '-', 'Snack');
            });
          }
          else if (type == text_addon_tab){
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
                  style: TextStyle(fontSize:type != text_category_tab ? 15 : 25,),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            type != text_category_tab ? Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: type != text_smoothie_tab ? Text(
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
      print(snack.name);
      item_ids.add(snack_id);
    }
    for (smoothie_order smoothie in smoothies)
    {
      int smooth_id = await helper_instance.get_item_id(smoothie.getSmoothie());
      print(smoothie.smoothie);
      item_ids.add(smooth_id);
      List<addon_order> addons = smoothie.getAddons();
      for (addon_order addon in addons)
      {
        print(addon.name);
        int addon_id = await helper_instance.get_item_id(addon.name);
        item_ids.add(addon_id);
      }
    }
    return item_ids;
  }

  // Alert popup that displays all items in order
  void order_summary()
  {
    final List<Map<String, String>> _sum = [];
    int i = 1;
    for (smoothie_order smoothie  in _current_order.getSmoothies())
      {
        final sm_row = {
          'index': i.toString(),
          'name': smoothie.getName(),
          'price': smoothie.getCost().toStringAsFixed(2),
        };
        _sum.add(sm_row);
        for (addon_order addon in smoothie.getAddons())
          {
            final ad_row = {
              'index': "",
              'name': addon.name,
              'price': addon.price.toStringAsFixed(2),
            };
            _sum.add(ad_row);
          }
        i += 1;
      }
    for (snack_order snack in _current_order.getSnacks())
      {
        final sn_row = {
          'index': i.toString(),
          'name': snack.name,
          'price': snack.price.toStringAsFixed(2),
        };
        _sum.add(sn_row);
        i +=1;
      }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
          return Stack(
            children: [
              Visibility(
                visible: !_order_processing,
                child: AlertDialog(
                  title: Text(_curr_customer != "None"
                      ? 'Order Summary for $_curr_customer'
                      : "Order Summary"),
                  //backgroundColor: Colors.white,
                  content: SizedBox(
                    width: screenWidth / 2,
                    height: screenHeight / 2,
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
                            DataColumn(label: Text('Price')),
                          ],
                          rows: _sum.map((rowData) {
                            final rowIndex = _sum.indexOf(rowData);
                            return DataRow(cells: [
                              DataCell(Text('${rowData['index']}')),
                              DataCell(Text('${rowData['name']}')),
                              DataCell(Text('${rowData['price']}')),
                            ]);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                        child: const Text('CONFIRM'),
                        onPressed: ()
                        {
                          Navigator.of(context).pop();
                          orderProccessing();
                        }
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: _order_processing,
                  child: const Positioned.fill(
                    child: SpinKitPouringHourGlass(color: Colors.red,),
                  )
              )
            ],
          );
        }
      );
  }

  void orderProccessing() async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
         return const Positioned.fill(
              child: SpinKitPouringHourGlass(color: Colors.red,));
        });
    Icon message_icon = const Icon(Icons.check);
    String message_text = 'Order Processed Successfully!';
    try {
      setState(() {
        _order_processing = true;
      });
      List<int> item_ids_in_order = await getIds();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd')
          .format(now);
      order_processing_helper order_helper = order_processing_helper();
      int trans_id = await order_helper
          .get_new_transaction_id();
      order_obj order_to_process = order_obj(
          trans_id,
          3,
          item_ids_in_order,
          double.parse(
              _current_order.price.toStringAsFixed(2)),
          _curr_customer,
          formattedDate,
          'completed');
      print(order_to_process.get_values());
      await order_helper.process_order(order_to_process);
      setState(() {
        _current_order.clear();
        _orderTable.clear();
        _addonTable.clear();
        _curr_customer = "None";
      });
    }
    catch (exception) {
      print(exception);
      message_icon = const Icon(Icons
          .error_outline_outlined);
      message_text = 'Unable To Process Order.';
    }
    finally {
      setState(() {
        _order_processing = false;
      });
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: message_icon,
              content: Text(message_text),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          });
    }
}



/*
  Future<void> process_order() async {

    List<int> item_ids_in_order = await getIds();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    order_processing_helper order_helper = order_processing_helper();
    int trans_id = await order_helper.get_new_transaction_id();
    order_obj order_to_process = order_obj(trans_id, 3, item_ids_in_order, double.parse(_current_order.price.toStringAsFixed(2)) , _curr_customer, formattedDate, 'completed');
    print(order_to_process.get_values());
    await order_helper.process_order(order_to_process);
    setState(() {
      _current_order.clear();
      _orderTable.clear();
      _addonTable.clear();
      _curr_customer = "";
    });
  }*/

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
          pageName: text_page_title,
          buttons: [
            IconButton(
              tooltip: text_ret_prev_view,
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
        body: _isLoading ?  Center(
          child: SpinKitCircle(color: _color_manager.text_color,),
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
                                  fontSize: 16,
                                ),
                                columnSpacing: 0,
                                columns:  [
                                  DataColumn(label: Text(text_datacolumn_index),),
                                  DataColumn(label: Text(text_datacolumn_name),),
                                  DataColumn(label: Text(text_datacolumn_size)),
                                  DataColumn(label: Text(text_datacolumn_price)),
                                  DataColumn(label: Text(text_datacolumn_edit)),
                                  DataColumn(label: Text(text_datacolumn_delete)),
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
                                            // Todo: find a more efficient way to change indexes
                                            _current_order.remove(int.parse(_orderTable.elementAt(rowIndex)['index']!));
                                            _orderTable.removeAt(rowIndex);
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
                                  headingTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  columnSpacing: 0,
                                  columns: [

                                    DataColumn(label: Text(text_datacolumn_index),),
                                    DataColumn(label: Text(text_datacolumn_name),),
                                    DataColumn(label: Text(text_datacolumn_price)),
                                    DataColumn(label: Text(text_datacolumn_price)),
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
                  ),

                  // Pane that show 
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: (screenWidth / 4) - 2.5, // 2.5 accounts for border
                          color: _color_manager.background_color.withAlpha(120),
                          child: TextButton(
                            onPressed: ()
                            {
                              // calls a popup text box that allows for input
                              customerInfo();
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 75,
                                  color: _color_manager.primary_color.withAlpha(222),
                                ),
                                Text(
                                  _curr_customer,
                                )
                              ],
                            ),
                          ),
                        ),

                        // Displays current order cost
                        Container(
                          width: screenWidth / 4,
                          color: _color_manager.background_color.withAlpha(50),
                          child: Center(
                            child: Text(
                              ''+ text_total + ': ${_current_order.price.abs().toStringAsFixed(2)}',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  // Pane of buttons for logging out, clearing order, and processing order
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
                              Navigator.pushReplacementNamed(context, Win_Login.route);
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
                            onPressed: (!_curr_editing
                                && (_current_order.getSmoothies().isNotEmpty
                                 || _current_order.getSnacks().isNotEmpty)
                            ) ? () {
                                order_summary();
                            } : null,
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
                      children: <Widget>
                      [
                        // Smoothie and Snack grid navigation
                        SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                width:screenWidth / 4 ,
                                child: tab(text_smoothies_tab, _color_manager.background_color, 0),
                              ),
                              SizedBox(
                                width:screenWidth / 4 ,
                                child: tab(text_snacks_tab, _color_manager.background_color, 1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight - 166,
                          child: Stack(
                            children: <Widget>
                            [
                              // Smoothie button grid
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
                                      child: buttonGrid(category_names, text_category_tab, _color_manager.active_color),
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
                                      child: buttonGrid(_snack_names, text_snack_tab, _color_manager.active_color.withRed(25).withGreen(180)),
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

                  // Smoothie Customization Pane
                  // - is used for both creating a new smoothie and editing a
                  //   smoothie currently in the order there with different processing
                  //   methods for each
                  Visibility(
                    visible: _activeMenu2 == 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: _color_manager.primary_color.withAlpha(122),
                          height: 125,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>
                            [
                              // Button that when pressed goes back to smoothie selection
                              SizedBox(
                                width: (screenWidth / 2) / 6,
                                height: 20,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20),
                                  child: !_curr_editing ? ElevatedButton(
                                    onPressed: ()
                                    {
                                      setState(()
                                      {
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

                              // widget used to cycle through smoothie size
                              // - medium is default
                              // TODO: (stretch) swap for buttons that display size and price
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    width: (screenWidth / 2) * (2/9),
                                    height: 22,
                                    child: ElevatedButton(
                                        onPressed: ()
                                        {
                                          setState(()
                                          {
                                            if (_curr_smoothie.getSize() == 'medium')
                                            {
                                              _curr_smoothie.setSmoothieSize('large');
                                            }
                                            else if (_curr_smoothie.getSize() == 'small')
                                            {
                                              _curr_smoothie.setSmoothieSize('medium');
                                            }
                                            else if (_curr_smoothie.getSize() == 'large')
                                            {
                                              _curr_smoothie.setSmoothieSize('small');
                                            }
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              _color_manager.active_color.withAlpha(200),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_drop_up,
                                          color: _color_manager.text_color,
                                        )
                                    ),
                                  ),
                                  Expanded(child: Container()), // basically padding
                                  SizedBox(
                                    width: (screenWidth / 2) * (2/3),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text
                                      // - size is converted to uppercase
                                      // - size is originally lowercase becuase our database
                                      //   has lower case size labels
                                        (
                                        "${_curr_smoothie.getName()} ${_curr_smoothie.getSize() == "large"
                                            ? text_large_label : _curr_smoothie.getSize() == "medium"
                                            ? text_medium_label : text_small_label}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: _color_manager.text_color.withAlpha(200),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()), // basically padding
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    width: (screenWidth / 2) * (2/9),
                                    height: 22,
                                    child: ElevatedButton(
                                        onPressed: ()
                                        {
                                          setState(()
                                          {
                                            if (_curr_smoothie.getSize() == 'medium')
                                            {
                                              _curr_smoothie.setSmoothieSize('small');
                                            }
                                            else if (_curr_smoothie.getSize() == 'small')
                                            {
                                              _curr_smoothie.setSmoothieSize('large');
                                            }
                                            else if (_curr_smoothie.getSize() == 'large'){

                                              _curr_smoothie.setSmoothieSize('medium');
                                            }
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              _color_manager.active_color.withAlpha(200),
                                          ),
                                        ),
                                        child: Icon(
                                            Icons.arrow_drop_down,
                                          color: _color_manager.text_color,
                                        )
                                    ),
                                  ),
                                ],
                              ),

                              // Adds smoothie with addons to order
                              SizedBox(
                                width: (screenWidth/ 2) / 6,
                                height: 20,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                                      child: _curr_editing ? const Icon(Icons.check, size: 35,) : const Icon(Icons.add_circle, size: 35),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Addon table
                        Container(
                          width: screenWidth / 2,
                          height: screenHeight - 186,
                          color: _color_manager.background_color,
                          child: buttonGrid(_addon_names, text_addon_tab, _color_manager.active_color.withBlue(255)),
                        ),
                      ],
                    ),
                  ),

                  // Menus for smoothie categories
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
                                    '$_curr_category ' + text_smoothies_tab,
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
                          height: screenHeight - 166, // 166 is pageHeader + menu header height
                          child: Stack(
                            children: <Widget>[
                              Visibility(
                                visible: _curr_category == "Get Fit",
                                child: buttonGrid(fitness_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Feel Energized",
                                child: buttonGrid(energy_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Manage Weight",
                                child: buttonGrid(weight_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Be Well",
                                child: buttonGrid(well_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Enjoy a Treat",
                                child: buttonGrid(treat_smoothies, "Smoothie", _color_manager.active_color),
                              ),
                              Visibility(
                                visible: _curr_category == "Seasonal",
                                child: buttonGrid(other_smoothies, "Smoothie", _color_manager.active_color),
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
import 'dart:async';
import 'package:csce315_project3_13/GUI/Menu%20Board/Board.dart';
import 'package:csce315_project3_13/Models/Order%20Models/smoothie_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../Inherited_Widgets/Color_Manager.dart';
import '../../Models/models_library.dart';
import '../../Services/menu_item_helper.dart';
import '../../Services/view_helper.dart';
import '../Components/Login_Button.dart';
import '../Components/Page_Header.dart';
import '../Pages/Login/Win_Login.dart';
import '../Pages/Manager_View/Win_Manager_View.dart';
import 'SmoothieBoard.dart';

class Win_Menu_Board extends StatefulWidget {
  static const String route = '/menu-board';
  Win_Menu_Board({Key? key}) : super(key: key);

  @override
  State<Win_Menu_Board> createState() => _Win_Menu_BoardState();
}


class _Win_Menu_BoardState extends State<Win_Menu_Board> {
  bool _isLoading = true;

  List<String> _smoothie_names = [];
  List<String> _snack_names = [];
  List<String> _addon_names = [];
  List<menu_item_obj> _all_menu_items = [];
  List<menu_item_obj> _smoothie_items = [];
  List<menu_item_obj> _snack_items = [];
  List<menu_item_obj> _addon_items = [];
  List<String> category_names = [];

  bool _view_smoothies = true;

  //Todo: get rid of these once categories are implemented
  List<String> fitness_smoothies = [];
  List<String> energy_smoothies = [];
  List<String> weight_smoothies = [];
  List<String> well_smoothies = [];
  List<String> treat_smoothies = [];
  List<String> other_smoothies = [];

  List<Map<String, String>> fitness_info = [];
  List<Map<String, String>> energy_info = [];
  List<Map<String, String>> weight_info = [];
  List<Map<String, String>> well_info = [];
  List<Map<String, String>> treat_info = [];
  List<Map<String, String>> other_info = [];
  List<Map<String, String>> snack_info = [];
  List<String> addon_info = [];

  Future<void> getData() async
  {
    view_helper name_helper = view_helper();
    menu_item_helper item_helper = menu_item_helper();

    _smoothie_items = await item_helper.getAllSmoothiesInfo();
    _snack_items = await item_helper.getAllSnackInfo();
    _addon_items = await item_helper.getAllAddonInfo();

    String clipped_name = "";
    int unclipped_length = 0;
    for (int i = 0; i < _smoothie_items.length; i++)
    {
      if (_smoothie_items[i].menu_item.contains("small"))
      {
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

    //for (menu_item_obj snack in _snack_items){_snack_names.add(snack.menu_item);}
    //for (menu_item_obj addon in _addon_items){_addon_names.add(addon.menu_item);}

    // TODO: get categories
    category_names = ["Feel Energized", "Get Fit", "Manage Weight", "Be Well", "Enjoy a Treat", "Seasonal"];

    // TODO: remove the need for big list, by checking for type before calling
    _all_menu_items = _smoothie_items;
    _all_menu_items.addAll(_snack_items);
    _all_menu_items.addAll(_addon_items);

    setState(()
    {
      _isLoading = false;
    });

    for (String smoothie in energy_smoothies)
    {
      energy_info.add({'name': smoothie,
        'small':
      _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie small')).item_price.toStringAsFixed(2),
        'medium':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie medium')).item_price.toStringAsFixed(2),
        'large':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie large')).item_price.toStringAsFixed(2),
      }
      );
    }

    for (String smoothie in fitness_smoothies)
    {
      fitness_info.add({'name': smoothie,
        'small':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie small')).item_price.toStringAsFixed(2),
        'medium':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie medium')).item_price.toStringAsFixed(2),
        'large':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie large')).item_price.toStringAsFixed(2),
      }
      );
    }

    for (String smoothie in weight_smoothies)
    {
      weight_info.add({'name': smoothie,
        'small':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie small')).item_price.toStringAsFixed(2),
        'medium':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie medium')).item_price.toStringAsFixed(2),
        'large':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie large')).item_price.toStringAsFixed(2),
      }
      );
    }

    for (String smoothie in well_smoothies)
    {
      well_info.add({'name': smoothie,
        'small':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie small')).item_price.toStringAsFixed(2),
        'medium':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie medium')).item_price.toStringAsFixed(2),
        'large':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie large')).item_price.toStringAsFixed(2),
      }
      );
    }

    for (menu_item_obj snack in _snack_items)
      {
        snack_info.add({
          'name': snack.menu_item,
          'price' : snack.item_price.toStringAsFixed(2),
        });
      }
    for (menu_item_obj addon in _addon_items)
    {
      addon_info.add(addon.menu_item);
    }
  }

  get login_helper_instance => null;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Page_Header(
      context: context,
      pageName: "Smoothie King Menu- Texas A&M MSC",
      buttons: [
        IconButton(
          tooltip: "Return to Manager View",
          padding: const EdgeInsets.only(left: 25, right: 10),
          onPressed: ()
          {
            Navigator.pushReplacementNamed(context,Win_Manager_View.route);
          },
          icon: Icon(Icons.circle, color: _color_manager.primary_color,),
          iconSize: 40,
        ),
      ],
    ),
      backgroundColor: _color_manager.background_color.withAlpha(122),
      body: _isLoading ? const SpinKitCircle(color: Colors.redAccent,)
          : Stack(
            children: [
              Visibility(
                visible: _view_smoothies,
                child: Container(
                margin: const EdgeInsets.all(10),
                    child: Column(
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SmoothieBoard(items: energy_info,
                          category: "Feel Energized",
                          width: screenWidth * (2/7),
                          height: screenHeight * (3/7),
                          color: Colors.green,
                        ),
                        SmoothieBoard(items: fitness_info,
                          category: "Get Fit",
                          width: screenWidth * (2/7),
                          height: screenHeight * (3/7),
                          color: Colors.redAccent,
                        ),
                        SmoothieBoard(items: weight_info,
                          category: "Manage Weight",
                          width: screenWidth * (2/7),
                          height: screenHeight * (3/7),
                          color: Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                  SizedBox(height: screenHeight / 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    SmoothieBoard(items: energy_info,
                      category: "Be Well",
                      width: screenWidth * (2/7),
                      height: screenHeight * (3/7),
                      color: Colors.pink,
                    ),
                    SmoothieBoard(items: fitness_info,
                      category: "Enjoy A Teat",
                      width: screenWidth * (2/7),
                      height: screenHeight * (3/7),
                      color: Colors.yellow.shade800,
                    ),
                    SmoothieBoard(items: weight_info,
                      category: "Seasonal",
                      width: screenWidth * (2/7),
                      height: screenHeight * (3/7),
                      color: Colors.deepOrange,
                    ),
                    ],
                  ),
                  Expanded(child: TextButton(
                    onPressed: (){
                      _view_smoothies = false;
                      setState(() {
                      });
                    }, child: Container(),
                  ))
                ],
                ),
              ),
              ),
              Visibility(
                  visible: !_view_smoothies,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight / 50,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Board(items: addon_info,
                              width: screenWidth * (5 / 8),
                              height: screenHeight * (6/7),
                              color: Colors.blueAccent,
                          ),
                          SmoothieBoard(items: snack_info,
                            category: "Snacks",
                            width: screenWidth * (2/7),
                            height: screenHeight * (6/7),
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                      Expanded(child: TextButton(
                        onPressed: (){
                          _view_smoothies = true;
                          setState(() {
                          });
                        }, child: Container(),
                      ))
                    ],
                  )
              )
            ],
      ),
    );
  }
}

import 'dart:async';
import 'package:csce315_project3_13/GUI/Menu%20Board/Board.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../Inherited_Widgets/Color_Manager.dart';
import '../../Models/models_library.dart';
import '../../Services/menu_item_helper.dart';
import '../../Services/view_helper.dart';
import '../Components/Login_Button.dart';
import '../Components/Page_Header.dart';
import '../Pages/Manager_View/Win_Manager_View.dart';
import 'SmoothieBoard.dart';

class Win_Menu_Board extends StatefulWidget {
  static const String route = '/menu-board';
  Win_Menu_Board({Key? key}) : super(key: key);

  @override
  State<Win_Menu_Board> createState() => _Win_Menu_BoardState();
}


class _Win_Menu_BoardState extends State<Win_Menu_Board> {

  // GOOGLE TRANSLATE VARIABLES BEGIN
  google_translate_API _google_translate_api = google_translate_API();
  String _current_lang = "";

  bool first_load = false;

  List<String> build_texts_original = [
  "Smoothie King Menu",
  "More",
  "Return to Manager View",
  "Feel Energized",
  "Get Fit",
  "Manage Weight",
  "Be Well",
  "Enjoy A Treat",
  "Seasonal",
  "Snacks",
    "Addons",
  ];
  List<String> build_texts = [
    "Smoothie King Menu",
    "More",
    "Return to Manager View",
    "Feel Energized",
    "Get Fit",
    "Manage Weight",
    "Be Well",
    "Enjoy A Treat",
    "Seasonal",
    "Snacks",
    "Addons",
  ];

  String text_smoothie_king_menu = "Smoothie King Menu";
  String text_more = "More";
  String text_ret_manager_view = "Return to Manager View";
  String text_feel_energized = "Feel Energized";
  String text_get_fit = "Get Fit";
  String text_manage_weight = "Manage Weight";
  String text_be_well = "Be Well";
  String text_enjoy_a_treat = "Enjoy A Treat";
  String text_seasonal = "Seasonal";
  String text_snacks = "Snacks";
  String text_addons = "Addons";

  List<String> smoothie_names = [];
  List<String> snack_names = [];
  List<String> addon_names = [];

  List<String> smoothie_names_translated = [];
  List<String> snack_names_translated = [];
  List<String> addon_names_translated = [];

  // GOOGLE TRANSLATE VARIABLES END



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
    other_info = [];
    view_helper name_helper = view_helper();
    menu_item_helper item_helper = menu_item_helper();

    _smoothie_items = await item_helper.getAllSmoothiesInfo();
    _snack_items = await item_helper.getAllSnackInfo();
    _addon_items = await item_helper.getAllAddonInfo();

    _snack_items = await item_helper.getAllSnackInfo();
    _addon_items = await item_helper.getAllAddonInfo();

    for(int i = 0; i < _smoothie_items.length; i++){
      smoothie_names.add(_smoothie_items[i].menu_item);
    }

    for(int i = 0; i < _snack_items.length; i++){
      snack_names.add(_snack_items[i].menu_item);
    }

    for(int i = 0; i < _addon_items.length; i++){
      addon_names.add(_addon_items[i].menu_item);
    }

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

    for (String smoothie in treat_smoothies)
    {
      treat_info.add({'name': smoothie,
        'small':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie small')).item_price.toStringAsFixed(2),
        'medium':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie medium')).item_price.toStringAsFixed(2),
        'large':
        _smoothie_items.firstWhere((menu_item_obj) => menu_item_obj.menu_item == ('$smoothie large')).item_price.toStringAsFixed(2),
      }
      );
    }





    print("About to print snack item");
    print(_snack_items.length);
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

    try {
      other_info = [];
      for (String smoothie in other_smoothies) {
        other_info.add({'name': smoothie,
          'small':
          _all_menu_items
              .firstWhere((menu_item_obj) =>
          menu_item_obj.menu_item == ('$smoothie small'))
              .item_price
              .toStringAsFixed(2),
          'medium':
          _all_menu_items
              .firstWhere((menu_item_obj) =>
          menu_item_obj.menu_item == ('$smoothie medium'))
              .item_price
              .toStringAsFixed(2),
          'large':
          _all_menu_items
              .firstWhere((menu_item_obj) =>
          menu_item_obj.menu_item == ('$smoothie large'))
              .item_price
              .toStringAsFixed(2),
        }
        );
      }
    }catch(e){}
  }

  get login_helper_instance => null;

  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;



    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {

      build_texts = (await _google_translate_api.translate_batch(build_texts_original,_translate_manager.chosen_language));
      text_smoothie_king_menu = build_texts[0];
      text_more = build_texts[1];
      text_ret_manager_view = build_texts[2];
      text_feel_energized = build_texts[3];
      text_get_fit = build_texts[4];
      text_manage_weight = build_texts[5];
      text_be_well = build_texts[6];
      text_enjoy_a_treat = build_texts[7];
      text_seasonal = build_texts[8];
      text_snacks = build_texts[9];
      text_addons = build_texts[10];


      _current_lang = _translate_manager.chosen_language;
      await getData();



      smoothie_names_translated = (await _google_translate_api.translate_batch(_smoothie_names,_translate_manager.chosen_language));

      snack_names_translated = (await _google_translate_api.translate_batch(snack_names,_translate_manager.chosen_language));

      addon_names_translated = (await _google_translate_api.translate_batch(addon_names,_translate_manager.chosen_language));


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
      context: context,
      pageName: text_smoothie_king_menu + " - Texas A&M MSC",
      buttons: [
        Login_Button(onTap: (){
          _view_smoothies = !_view_smoothies;
          setState(() {
          });
        }, buttonName: text_more),
        IconButton(
          tooltip: text_ret_manager_view,
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
                          SmoothieBoard(
                            orginal_names: _smoothie_names,
                            translated_names: smoothie_names_translated,
                            items: energy_info,
                            isSnacks: false,
                            category: text_feel_energized,
                            width: screenWidth * (2/7),
                            height: screenHeight * (3/7),
                            color: Colors.green,
                          ),
                          SmoothieBoard(
                            orginal_names: _smoothie_names,
                            translated_names: smoothie_names_translated,
                            items: fitness_info,
                            isSnacks: false,
                            category: text_get_fit,
                            width: screenWidth * (2/7),
                            height: screenHeight * (3/7),
                            color: Colors.redAccent,
                          ),
                          SmoothieBoard(
                            orginal_names: _smoothie_names,
                            translated_names: smoothie_names_translated,
                            items: weight_info,
                            isSnacks: false,
                            category: text_manage_weight,
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
                          SmoothieBoard(
                            orginal_names: _smoothie_names,
                            translated_names: smoothie_names_translated,
                            items: well_info,
                            isSnacks: false,
                            category: text_be_well,
                            width: screenWidth * (2/7),
                            height: screenHeight * (3/7),
                            color: Colors.pink,
                          ),
                          SmoothieBoard(
                            orginal_names: _smoothie_names,
                            translated_names: smoothie_names_translated,
                            items: treat_info,
                            isSnacks: false,
                            category: text_enjoy_a_treat,
                            width: screenWidth * (2/7),
                            height: screenHeight * (3/7),
                            color: Colors.yellow.shade800,
                          ),
                          SmoothieBoard(
                            orginal_names: _smoothie_names,
                            translated_names: smoothie_names_translated,
                            items: other_info,
                            isSnacks: false,
                            category: text_seasonal,
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
                          Board(
                            orginal_names: addon_names,
                            translated_names: addon_names_translated,
                            title: text_addons,
                            items: addon_info,
                            width: screenWidth * (5 / 8),
                            height: screenHeight * (6/7),
                            color: Colors.blueAccent,
                          ),
                          SmoothieBoard(
                            orginal_names: snack_names,
                            translated_names: snack_names_translated,
                            items: snack_info,
                            isSnacks: true,
                            category: text_snacks,
                            width: screenWidth * (2/7),
                            height: screenHeight * (6/7),
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ],
                  )
              ),

            ],
      ),
    );
  }
}

import 'package:csce315_project3_13/GUI/Menu%20Board/Win_Menu_Board.dart';
import 'package:csce315_project3_13/GUI/Pages/Sales%20Reports/Win_Itemized_Reports.dart';
import 'package:csce315_project3_13/GUI/Pages/Sales%20Reports/Win_Reports_Hub.dart';
import 'package:csce315_project3_13/GUI/Pages/Inventory/Win_Order_Inventory.dart';
import 'package:csce315_project3_13/GUI/Pages/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/GUI/Pages/Server_View/Win_Server_View.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Pages/Inventory/Win_View_Inventory.dart';
import 'package:csce315_project3_13/GUI/Pages/Loading/Loading_Page.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Create_Account.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Reset_Password.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/WIn_Edit_Smoothie.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_Add_Smoothie.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
import 'package:csce315_project3_13/GUI/Pages/Order/Win_Order.dart';
import 'package:csce315_project3_13/GUI/Pages/Test%20Pages/Win_Functions_Test_Page.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Weather_Manager.dart';
import 'package:csce315_project3_13/Inherited_Widgets/What_Sales_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:csce315_project3_13/Services/weather_API.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'GUI/Pages/Customer/Win_Cust_Order.dart';
import 'GUI/Pages/Login/Win_Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'GUI/Pages/Sales Reports/Win_What_Sales.dart';
import 'GUI/Pages/Sales Reports/Win_Z_Reports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  // initializes colors for the app
  Color primary_color = Color(0xFF932126);
  Color secondary_color = Color(0xFF932126);
  Color background_color = Color(0xFFE38286);
  Color text_color = Color(0xFFFFFFFF);
  Color active_color = Color(0xFF25A8A2);
  Color hover_color = Color(0xFF22bfb9);
  Color inactive_color = Color(0xFF00716C);
  Color active_size_color = Color(0xFF3088D1);
  Color active_confirm_color = Color(0xFF6BCF54);
  Color active_deny_color = Color(0xFFC30F0E);

  int selected_option_index = 0;


  // changes back to original colors
  void reset_colors(){
    setState(() {
      primary_color = Color(0xFF932126);
      secondary_color = Color(0xFF932126);
      background_color = Color(0xFFE38286);
      text_color = Color(0xFFFFFFFF);
      active_color = Color(0xFF25A8A2);
      hover_color = Color(0xFF22bfb9);
      inactive_color = Color(0xFF00716C);
      active_size_color = Color(0xFF3088D1);
      active_confirm_color = Color(0xFF6BCF54);
      active_deny_color = Color(0xFFC30F0E);
      selected_option_index = 0;
    });
    set_color_option_pref('standard');
  }


  // option for deuteranopia
  void option_deuteranopia(){
    print("deuteranopia selected");
    setState(() {
      primary_color = Color(0xFF009E73);
      secondary_color = Color(0xFF009E73);
      background_color = Color(0xFFF0E442);
      text_color = Colors.black;
      active_color = Color(0xFFE69F00);
      hover_color = Color(0xFFD55E00);
      inactive_color = Color(0x55E69F00);
      active_size_color = Color(0xFF3088D1);
      active_confirm_color = Color(0xFF6BCF54);
      active_deny_color = Color(0xFFC30F0E);
      selected_option_index = 1;
    });
    set_color_option_pref('deuteranopia');
  }


  // color pallet for protanopia
  void option_protanopia(){
    setState(() {
      primary_color = Color(0xFF009E73);
      secondary_color = Color(0xFF009E73);
      background_color = Color(0xFFF0E442);
      text_color = Colors.black;
      active_color = Color(0xFFE69F00);
      hover_color = Color(0xFFD55E00);
      inactive_color = Color(0x55E69F00);
      active_size_color = Color(0xFF3088D1);
      active_confirm_color = Color(0xFF6BCF54);
      active_deny_color = Color(0xFFC30F0E);
      selected_option_index = 1;
    });
    set_color_option_pref('protanopia');
  }


  // color pallet for tritanopia
  void option_tritanopia(){
    setState(() {
      primary_color = Color(0xFF009E73);
      secondary_color = Color(0xFF009E73);
      background_color = Color(0xFF56B4E9);
      text_color = Colors.black;
      active_color = Color(0xFFF0E442);
      hover_color = Color(0xFFD55E00);
      inactive_color = Color(0xFFCC79A7);
      active_size_color = Color(0xFF3088D1);
      active_confirm_color = Color(0xFF6BCF54);
      active_deny_color = Color(0xFFC30F0E);
      selected_option_index = 2;
    });
    set_color_option_pref('tritanopia');
  }





  // changes the color depending on the preferences
  void set_color_scheme(String pref_color_choice){
    if(pref_color_choice == 'standard'){

    }else if(pref_color_choice == 'deuteranopia'){
      option_deuteranopia();
    }else if(pref_color_choice == 'protanopia'){
      option_protanopia();
    }else if(pref_color_choice == 'tritanopia'){
      option_tritanopia();
    }
  }

  // stores the value of high_contrast as a preference
  void set_color_option_pref(String color_pref_choice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('color_option', color_pref_choice);
  }





  // timer for getting the weather

  late weather_API _weather_api;

  late Timer _timer;

  String current_condition = "Can't fetch";
  String current_tempurature = "weather";

  List<String> conditions_list_original = ["Clear", "Drizzle", "Rain", "Clouds", "Mist", "Thunderstorm"];
  List<String> conditions_list = ["Clear", "Drizzle", "Rain", "Clouds", "Mist", "Thunderstorm"];

  void startTimer() async {
    print("timer started");

    String current_weather_cond = "Can't fetch";
    String current_weather_temp = "weather";
    try{
      current_weather_cond = await _weather_api.get_condition();
      current_weather_temp = await _weather_api.get_temperature();
    }catch(e){
     print("could not fetch weather");
    }




      // update the weather values
      print("Get weather data");

      current_condition = current_weather_cond;
      current_tempurature = current_weather_temp;
      try{
        current_condition = (await google_translate_API().translate_batch(<String>[current_condition], chosen_language))[0];
      }catch(e){
      print("could not update weather condition");
      print(e);
      }
    setState(() {});

    _timer = Timer.periodic(Duration(seconds: 60), (timer) async {
      try{
        current_weather_cond = await _weather_api.get_condition();
        // current_weather_cond = await
        current_weather_temp = await _weather_api.get_temperature();
      }catch(e){
        print("could not fetch weather");
      }
      print(current_weather_cond);
      print(current_weather_temp);

      // update the weather values
      print("A minute has passed, update weather data");

      current_condition = current_weather_cond;
      current_tempurature = current_weather_temp;

      try{
        current_condition = (await google_translate_API().translate_batch(<String>[current_condition], chosen_language))[0];
      }catch(e){
        print("could not update weather condition");
        print(e);
      }

      setState(() {



      });
    });
  }

  Future<void> change_condition_language() async {
    try{
      conditions_list = await google_translate_API().translate_batch(conditions_list_original, chosen_language);
    }catch(e){
      print("Could not change condition list language");
      print(e);
    }



  }

  //Google translate
  String chosen_language = "en";

  void change_language(String newLanguage) async {

      chosen_language = newLanguage;
      await change_condition_language();
      startTimer();

    setState(() {
    });

    // startTimer();

    set_language_option_pref(newLanguage);
  }

  void set_language_option_pref(String language_pref_choice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_option', language_pref_choice);
  }

  // finds what the value for high_contrast is
  void get_preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? got_color_choice = prefs.getString('color_option');
    if(got_color_choice == null){
      await prefs.setString('color_option', 'standard');
      got_color_choice = 'standard';
    }
    String? got_language_choice = prefs.getString('language_option');
    if(got_language_choice == null){
      await prefs.setString('language_option', 'en');
      got_language_choice = 'en';
    }
    set_color_scheme(got_color_choice);
    change_language(got_language_choice as String);
  }

  //For what sales
  String date1 = "01/20/2022";
  String date2 = "01/21/2022";
  bool set_dates = false;
  void change_date(String new_date1, String new_date2){
    date1 = new_date1;
    date2 = new_date2;
    set_dates = true;
    setState(() {

    });
  }




  @override
  void initState() {
    _weather_api = weather_API();

    //gets the preferences
    get_preferences();
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return What_Sales_Manager(
      set_dates: set_dates,
      date1: date1,
      date2: date2,
      change_dates: change_date,

      child: Translate_Manager(
        chosen_language: chosen_language,
        change_language: change_language,
        child: Weather_Manager(
          conditions_list: conditions_list,
          current_tempurature: current_tempurature,
          current_condition: current_condition,
          child: Color_Manager(
            // This class stores the color values for the web app
            selected_option_index: selected_option_index,
            reset_colors: reset_colors,
            option_deuteranopia: option_deuteranopia,
            option_protanopia: option_protanopia,
            option_tritanopia: option_tritanopia,
            primary_color: primary_color,
            secondary_color: secondary_color,
            background_color: background_color,
            text_color: text_color,
            active_color: active_color,
            hover_color: hover_color,
            inactive_color: inactive_color,
            active_size_color: active_size_color,
            active_confirm_color: active_confirm_color,
            active_deny_color: active_deny_color,

            child: MaterialApp(
              title: 'Smoothie King App',
              theme: ThemeData(
                primarySwatch: Colors.red,
              ),
              routes:  <String, WidgetBuilder>{
                Win_Login.route: (BuildContext context) => Win_Login(),
                Win_Reset_Password.route: (BuildContext context) => Win_Reset_Password(),
                Win_Create_Account.route: (BuildContext context) => Win_Create_Account(),
                Win_Manager_View.route: (BuildContext context) => Win_Manager_View(),
                Win_Server_View.route: (BuildContext context) => Win_Server_View(),
                Win_Functions_Test_Page.route: (BuildContext context) => Win_Functions_Test_Page(),
                Win_Loading_Page.route: (BuildContext context) => Win_Loading_Page(),
                Win_View_Menu.route :(BuildContext context) => Win_View_Menu(),
                Win_Edit_Smoothie.route: (BuildContext context) => Win_Edit_Smoothie(),
                Win_Add_Smoothie.route: (BuildContext context) => Win_Add_Smoothie(),
                Win_Order.route: (BuildContext context) => Win_Order(),
                Win_View_Inventory.route :(BuildContext context) => Win_View_Inventory(),
                Win_What_Sales.route :(BuildContext context) =>  Win_What_Sales(),
                Win_Order_Inventory.route :(BuildContext context) => Win_Order_Inventory(),
                Win_Reports_Hub.route: (BuildContext context) => Win_Reports_Hub(),
                Win_Z_Reports.route: (BuildContext context) => Win_Z_Reports(),
                Win_Itemized_Reports.route: (BuildContext context) => Win_Itemized_Reports(),
                Win_Menu_Board.route : (BuildContext context) => Win_Menu_Board(),
                Win_Cust_Order.route: (BuildContext context) => Win_Cust_Order(),
              },
              initialRoute: Win_Manager_View.route,
            ),
          ),
        ),
      ),
    );
  }
}


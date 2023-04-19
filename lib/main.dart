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
import 'package:csce315_project3_13/GUI/Pages/Loading/Loading_Order_Win.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/Server_View/Win_Server_View.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Weather_Manager.dart';
import 'package:csce315_project3_13/Services/weather_API.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'GUI/Pages/Login/Win_Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

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
    });
    set_color_option_pref('tritanopia');
  }



  // finds what the value for high_contrast is
  void get_preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? got_color_choice = prefs.getString('color_option');
    if(got_color_choice == null){
      await prefs.setString('color_option', 'standard');
      got_color_choice = 'standard';
    }
    set_color_scheme(got_color_choice);
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

  void startTimer() async {

    String current_weather_cond = "Can't fetch";
    String current_weather_temp = "weather";
    try{
      current_weather_cond = await _weather_api.get_condition();
      current_weather_temp = await _weather_api.get_temperature();
    }catch(e){
     print("could not fetch weather");
    }


    setState(() {

      // update the weather values
      print("Get weather data");

      current_condition = current_weather_cond;
      current_tempurature = current_weather_temp;

    });

    _timer = Timer.periodic(Duration(seconds: 60), (timer) async {
      try{
        current_weather_cond = await _weather_api.get_condition();
        current_weather_temp = await _weather_api.get_temperature();
      }catch(e){
        print("could not fetch weather");
      }
      print(current_weather_cond);
      print(current_weather_temp);
      setState(() {

          // update the weather values
          print("A minute has passed, update weather data");

          current_condition = current_weather_cond;
          current_tempurature = current_weather_temp;

      });
    });
  }

  //Google translate
  String chosen_language = "en";

  void change_language(String newLanguage){
    setState(() {
      chosen_language = newLanguage;
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
    return Translate_Manager(
      chosen_language: chosen_language,
      change_language: change_language,
      child: Weather_Manager(
        current_tempurature: current_tempurature,
        current_condition: current_condition,
        child: Color_Manager(
          // This class stores the color values for the web app
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
              Loading_Order_Win.route: (BuildContext context) => Loading_Order_Win(),
              Win_Order.route: (BuildContext context) => Win_Order(),
              Win_View_Inventory.route :(BuildContext context) => Win_View_Inventory(),
            },
            initialRoute:  Win_Login.route,
          ),
        ),
      ),
    );
  }
}


import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Pages/Loading/Loading_Page.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Create_Account.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Reset_Password.dart';
import 'package:csce315_project3_13/GUI/Pages/Order/Win_Order.dart';
import 'package:csce315_project3_13/GUI/Pages/Test%20Pages/Win_Functions_Test_Page.dart';
import 'package:csce315_project3_13/GUI/Pages/Loading/Loading_Order_Win.dart';
import 'package:csce315_project3_13/Manager_View/Win_Manager_View.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'GUI/Pages/Login/Win_Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // keeps track of if it's high contrast or not
  bool is_high_contrast = false;

  // changes back to original colors
  void reset_colors(){
    setState(() {
      is_high_contrast = false;
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
    set_high_contrast(false);
  }

  // changes to high contrast colors
  void color_blind_option_1(){
    setState(() {
      is_high_contrast = true;
      primary_color = Colors.green[900] as Color;
      secondary_color = Colors.green[900] as Color;
      background_color = Color(0xFFE38286);
      text_color = Color(0xFFFFFFFF);
      active_color = Colors.blue[900] as Color;
      hover_color = Colors.blue[900] as Color;
      inactive_color = Color(0xFF00716C);
      active_size_color = Color(0xFF3088D1);
      active_confirm_color = Color(0xFF6BCF54);
      active_deny_color = Color(0xFFC30F0E);
    });
    set_high_contrast(true);
  }

  // finds what the value for high_contrast is
  void get_preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? got_high_contrast = prefs.getBool('high_contrast');
    if(got_high_contrast == null){
      await prefs.setBool('high_contrast', false);
      got_high_contrast = false;
    }
    set_color_scheme(got_high_contrast);
  }

  // changes the color depending on the preferences
  void set_color_scheme(bool pref_high_contrast){
    if(pref_high_contrast){
      color_blind_option_1();
    }
  }

  // stores the value of high_contrast as a preference
  void set_high_contrast(bool high_contrast) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('high_contrast', high_contrast);
  }

  @override
  void initState() {
    //gets the preferences
    get_preferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Color_Manager(
      // This class stores the color values for the web app
      is_high_contrast: is_high_contrast,
      reset_colors: reset_colors,
      color_blind_option_1: color_blind_option_1,
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
          Win_Functions_Test_Page.route: (BuildContext context) => Win_Functions_Test_Page(),
          Win_Loading_Page.route: (BuildContext context) => Win_Loading_Page(),
          Loading_Order_Win.route: (BuildContext context) => Loading_Order_Win(),
          Win_Order.route: (BuildContext context) => Win_Order(),
        },
        initialRoute: Win_Login.route,
      ),
    );
  }
}


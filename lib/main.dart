import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/Colors/constants.dart';
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
  Color hover_color = Color(0x5525A8A2);
  Color inactive_color = Color(0xFF00716C);
  Color active_size_color = Color(0xFF3088D1);
  Color active_confirm_color = Color(0xFF6BCF54);
  Color active_deny_color = Color(0xFFC30F0E);


  void reset_colors(){
    setState(() {
      primary_color = Color(0xFF932126);
      secondary_color = Color(0xFF932126);
      background_color = Color(0xFFE38286);
      text_color = Color(0xFFFFFFFF);
      active_color = Color(0xFF25A8A2);
      hover_color = Color(0x5525A8A2);
      inactive_color = Color(0xFF00716C);
      active_size_color = Color(0xFF3088D1);
      active_confirm_color = Color(0xFF6BCF54);
      active_deny_color = Color(0xFFC30F0E);
    });
  }

  void color_blind_option_1(){
    setState(() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Color_Manager(
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


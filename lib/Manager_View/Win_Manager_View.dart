import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:csce315_project3_13/GUI/Pages/Inventory/Win_View_Inventory.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Login.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:csce315_project3_13/Services/login_helper.dart';
import 'package:flutter/material.dart';

import '../GUI/Pages/Order/Win_Order.dart';

class Win_Manager_View extends StatefulWidget {
  static const String route = '/manager-view';
  const Win_Manager_View({Key? key}) : super(key: key);

  @override
  State<Win_Manager_View> createState() => _Win_Manager_ViewState();
}

class _Win_Manager_ViewState extends State<Win_Manager_View> {

  //Keeps track of whether to update name or not
  bool call_set_translation = true;

  //Strings for display
  List<String> list_page_texts_originals = ["Manager View", "Log out", "Order", "Manage Menu","Manage Inventory" ];
  List<String> list_page_texts = ["Manager View", "Log out", "Order", "Manage Menu", "Manage Inventory"  ];
  String text_page_header = "Manager View";
  String text_log_out_button = "Log out";
  String text_order_button = "Order";
  String text_manage_menu = "Manage Menu";
  String text_manage_inventory = "Manage Inventory";

  google_translate_API _google_translate_api = google_translate_API();



  login_helper login_helper_instance = login_helper();

  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);

    // ToDo Implement the below translation functionality
    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {
      call_set_translation = false;

      //set the new Strings here
      list_page_texts = (await _google_translate_api.translate_batch(list_page_texts_originals,_translate_manager.chosen_language));
      text_page_header = list_page_texts[0];
      text_log_out_button = list_page_texts[1];
      text_order_button = list_page_texts[2];
      text_manage_menu = list_page_texts[3];
      text_manage_inventory = list_page_texts[4];

      setState(() {
      });
    }

    if(call_set_translation){
      set_translation();
    }else{
      call_set_translation = true;
    }

    //Translation functionality end


    return Scaffold(
      appBar: Page_Header(
          context: context,
          pageName: text_page_header,
          buttons: [
            Login_Button(onTap: (){
              login_helper_instance.sign_out();
              Navigator.pushReplacementNamed(context, Win_Login.route);
            }, buttonName: text_log_out_button,
            fontSize: 15,
            ),
          ],

      ),
      backgroundColor: _color_manager.background_color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Login_Button(onTap: (){
              Navigator.pushReplacementNamed(context,Win_Order.route);
            }, buttonName: text_order_button),
            Login_Button(onTap: (){
              Navigator.pushReplacementNamed(context,Win_View_Menu.route);
            }, buttonName: text_manage_menu, fontSize: 18, buttonWidth: 180,),
            Login_Button(onTap: (){
              Navigator.pushReplacementNamed(context,Win_View_Inventory.route);
            }, buttonName: text_manage_inventory, fontSize: 18, buttonWidth: 180,),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

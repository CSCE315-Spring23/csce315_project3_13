import 'package:csce315_project3_13/GUI/Menu%20Board/Win_Menu_Board.dart';
import 'package:csce315_project3_13/GUI/Pages/Order/Win_Order.dart';
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

import '../Sales Reports/Win_Reports_Hub.dart';

class Win_Manager_View extends StatefulWidget {
  static const String route = '/manager-view';
  const Win_Manager_View({Key? key}) : super(key: key);

  @override
  State<Win_Manager_View> createState() => _Win_Manager_ViewState();
}

class _Win_Manager_ViewState extends State<Win_Manager_View> {

  //Keeps track of whether to update name or not
  bool call_set_translation = true;
  google_translate_API _google_translate_api = google_translate_API();

  //Strings for display
  List<String> list_page_texts_originals = ["Manager View", "Log out", "Order", "Manage Menu","Manage Inventory", "What Sells Together", "Menu Board", "Reports Hub" ];
  List<String> list_page_texts = ["Manager View", "Log out", "Order", "Manage Menu", "Manage Inventory",  "What Sells Together", "Menu Board", "Reports Hub" ];
  String text_page_header = "Manager View";
  String text_log_out_button = "Log out";
  String text_order_button = "Order";
  String text_manage_menu = "Manage Menu";
  String text_manage_inventory = "Manage Inventory";
  String text_view_what_sales = "What Sells Together";
  String text_menu_board = "Menu Board";
  String text_reports_hub = "Reports Hub";





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
      text_view_what_sales = list_page_texts[5];
      text_menu_board = list_page_texts[6];
      text_reports_hub = list_page_texts[7];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Login_Button(onTap: (){
                  Navigator.pushReplacementNamed(context,Win_Reports_Hub.route);
                }, buttonName: text_reports_hub, fontSize: 18, buttonWidth: 180,),
                Login_Button(onTap: (){
                  Navigator.pushReplacementNamed(context,Win_Menu_Board.route);
                }, buttonName: text_menu_board, fontSize: 18, buttonWidth: 180,),
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

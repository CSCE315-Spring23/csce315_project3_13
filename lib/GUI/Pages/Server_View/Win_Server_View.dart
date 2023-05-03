/// The initial view of the server.

import 'package:csce315_project3_13/GUI/Pages/Order/Win_Order.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Login.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:csce315_project3_13/Services/login_helper.dart';
import 'package:flutter/material.dart';

class Win_Server_View extends StatefulWidget {
  static const String route = '/server-view';
  const Win_Server_View({Key? key}) : super(key: key);

  @override
  State<Win_Server_View> createState() => _Win_Server_ViewState();
}

class _Win_Server_ViewState extends State<Win_Server_View> {

  login_helper login_helper_instance = login_helper();

  //Keeps track of whether to update name or not
  bool call_set_translation = true;

  google_translate_API _google_translate_api = google_translate_API();

  //Strings for display
  List<String> list_page_texts_originals = ["Server View", "Log out", "Order", ];
  List<String> list_page_texts = ["Server View", "Log out", "Order", ];
  String text_page_header = "Server View";
  String text_log_out_button = "Log out";
  String text_order_button = "Order";

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


          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

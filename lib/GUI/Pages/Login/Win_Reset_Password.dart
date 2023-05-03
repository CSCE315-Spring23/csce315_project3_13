/// Window for resetting a password.

import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Contrast_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Login_TextField.dart';
import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:csce315_project3_13/GUI/Components/Settings_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Login.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:csce315_project3_13/Services/login_helper.dart';
import 'package:flutter/material.dart';


class Win_Reset_Password extends StatefulWidget {
  static const String route = '/reset-password';
  const Win_Reset_Password({Key? key}) : super(key: key);

  @override
  State<Win_Reset_Password> createState() => _Win_Reset_PasswordState();
}

class _Win_Reset_PasswordState extends State<Win_Reset_Password> {

  //Keeps track of whether to update name or not
  bool call_set_translation = true;

  //Strings for display
  List<String> list_page_texts_originals = ["Reset Password", "Back",  "Enter your email", "Email", "Reset"];
  List<String> list_page_texts = ["Reset Password", "Back",  "Enter your email", "Email","Reset"];
  String text_page_header = "Reset Password";
  String text_back_button = "Back";
  String text_enter_email =  "Enter your email";
  String text_email_label = "Email";
  String text_reset_email = "Reset";

  google_translate_API _google_translate_api = google_translate_API();


  late TextEditingController _email_controller;


  login_helper _login_helper_instance = login_helper();


  void _reset_password({required String user_email, required BuildContext context})async{
    await _login_helper_instance.reset_password(user_email: user_email, context: context);
    Navigator.pushReplacementNamed(context, Win_Login.route);
  }

  @override
  void initState() {
    super.initState();
    _email_controller = TextEditingController();

  }

  @override
  void dispose() {
    _email_controller.dispose();
    super.dispose();
  }


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
      text_back_button = list_page_texts[1];
      text_enter_email =  list_page_texts[2];
      text_email_label = list_page_texts[3];
      text_reset_email = list_page_texts[4];

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
      appBar: Page_Header(context: context,
        pageName: text_page_header,
        buttons: [

          Login_Button(onTap: (){
            Navigator.pushReplacementNamed(context, Win_Login.route);
          }, buttonName: text_back_button,
              fontSize: 15
          ),
        ],
      ),

      backgroundColor: _color_manager.background_color,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                 text_enter_email,
                  style: TextStyle(
                    color: _color_manager.text_color,
                    fontSize: 30,
                  ),
                ),
              ),

              Login_TextField(
                context: context,
                textController: _email_controller,
                onSubmitted: (my_text){
                  _reset_password(user_email: _email_controller.text, context: context);
                },
                  labelText: text_email_label,
                ),




              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Login_Button(onTap: (){
                  _reset_password(user_email: _email_controller.text, context: context);
                }, buttonName: text_reset_email,
                buttonWidth: 150
                ),
              ),


            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

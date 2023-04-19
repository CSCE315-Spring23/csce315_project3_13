import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Contrast_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Login_TextField.dart';
import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:csce315_project3_13/GUI/Components/Settings_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Login.dart';
import 'package:csce315_project3_13/Services/login_helper.dart';
import 'package:flutter/material.dart';


class Win_Reset_Password extends StatefulWidget {
  static const String route = '/reset-password';
  const Win_Reset_Password({Key? key}) : super(key: key);

  @override
  State<Win_Reset_Password> createState() => _Win_Reset_PasswordState();
}

class _Win_Reset_PasswordState extends State<Win_Reset_Password> {


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


    return Scaffold(
      appBar: Page_Header(context: context,
        pageName: "Reset Password",
        buttons: [

          Login_Button(onTap: (){
            Navigator.pushReplacementNamed(context, Win_Login.route);
          }, buttonName: "Back",
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
                  'Enter your email',
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
                  labelText: 'Email',
                ),




              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Login_Button(onTap: (){
                  _reset_password(user_email: _email_controller.text, context: context);
                }, buttonName: "Reset email",
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

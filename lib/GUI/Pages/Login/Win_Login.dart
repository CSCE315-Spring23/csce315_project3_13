import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Contrast_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Login_TextField.dart';
import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:csce315_project3_13/GUI/Components/Settings_Button.dart';
import 'package:csce315_project3_13/GUI/Pages/Loading/Loading_Order_Win.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Create_Account.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Reset_Password.dart';
import 'package:csce315_project3_13/Manager_View/Win_Manager_View.dart';
import 'package:csce315_project3_13/Services/login_helper.dart';
import 'package:flutter/material.dart';

class Win_Login extends StatefulWidget {
  static const String route = '/login';
  const Win_Login({super.key});

  @override
  State<Win_Login> createState() => _Win_LoginState();
}

class _Win_LoginState extends State<Win_Login> {

  bool _show_password = false;

  late TextEditingController _username_controller;
  late TextEditingController _password_controller;

  login_helper _login_helper_instance = login_helper();

  void _switch_show_password(){
    setState(() {
      _show_password = !_show_password;
    });
  }

  void _login(BuildContext context){
    _login_helper_instance.login(context: context, username: _username_controller.text, password: _password_controller.text);
  }



  @override
  void initState() {
    super.initState();
    _username_controller = TextEditingController();
    _password_controller = TextEditingController();
  }

  @override
  void dispose() {
    _username_controller.dispose();
    _password_controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);
    return Scaffold(
      backgroundColor: _color_manager.background_color,
      appBar: Page_Header(
          context: context,
          pageName: "Login",
          buttons: <Widget>[
            const Settings_Buttons(),

            const Contrast_Button(),



            Login_Button(onTap: (){
              Navigator.pushReplacementNamed(context, Win_Reset_Password.route);
            }, buttonName: "Reset password",
              fontSize: 15,
            ),

          ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Enter your email and password:',
                  style: TextStyle(
                    fontSize: 30,
                    color: _color_manager.text_color,
                  ),
                ),
              ),

              Login_TextField(context: context,
                textController: _username_controller,
                labelText: 'Email',
              ),

              Login_TextField(context: context,
                textController: _password_controller,
                obscureText: !_show_password,
                labelText: 'Password',
                onSubmitted: (){
                _login(context);
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      fillColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                      Set<MaterialState> interactiveStates = <MaterialState>{
                      MaterialState.pressed,
                      MaterialState.hovered,
                      MaterialState.focused,
                      };
                      return _color_manager.active_color;
                      }),
                    hoverColor: _color_manager.hover_color,
                    activeColor: _color_manager.active_color,
                    checkColor: _color_manager.text_color,
                      value: _show_password,
                      onChanged: (changed_value){
                        _switch_show_password();
                      }),
                  Text("Show password",
                  style: TextStyle(
                    color: _color_manager.text_color,
                  ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Login_Button(onTap: (){
                  _login(context);
                }, buttonName: "Login",
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Login_Button(onTap: (){
                 Navigator.pushReplacementNamed(context, Win_Manager_View.route);
                }, buttonName: "Login as guest",
                  fontSize: 14,
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

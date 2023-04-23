import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:csce315_project3_13/GUI/Pages/Inventory/Win_View_Inventory.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Login.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
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

  login_helper login_helper_instance = login_helper();

  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);
    return Scaffold(
      appBar: Page_Header(
          context: context,
          pageName: "Manager View",
          buttons: [
            Login_Button(onTap: (){
              login_helper_instance.sign_out();
              Navigator.pushReplacementNamed(context, Win_Login.route);
            }, buttonName: "Log out",
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
            }, buttonName: "Order"),
            Login_Button(onTap: (){
              Navigator.pushReplacementNamed(context,Win_View_Menu.route);
            }, buttonName: "Manage Menu", fontSize: 18, buttonWidth: 180,),
            Login_Button(onTap: (){
              Navigator.pushReplacementNamed(context,Win_View_Inventory.route);
            }, buttonName: "Manage Inventory", fontSize: 18, buttonWidth: 180,),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

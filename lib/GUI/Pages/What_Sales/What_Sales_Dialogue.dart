import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/GUI/Components/Login_TextField.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:flutter/material.dart';


class WhatSalesDialogue extends StatefulWidget {
  const WhatSalesDialogue({Key? key}) : super(key: key);

  @override
  State<WhatSalesDialogue> createState() => _WhatSalesDialogueState();
}

class _WhatSalesDialogueState extends State<WhatSalesDialogue> {

  late TextEditingController _date1Controller;
  late TextEditingController _date2Controller;


  @override
  void initState() {
    _date1Controller = TextEditingController();
    _date2Controller = TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final _color_manager = Color_Manager.of(context);

    return AlertDialog(
      title: Text("Choose dates:",
      style: TextStyle(
        color: _color_manager.text_color,
      ),
      ),
      backgroundColor: _color_manager.background_color,
      content: Center(
        child: Column(
          children: [
            Login_TextField(context: context, textController: _date1Controller, labelText: "Start date"),
            Login_TextField(context: context, textController: _date2Controller, labelText: "End date"),
          ],
        ),
      ),
      actions: <Widget>[
        Login_Button(
          onTap: (){

            Navigator.of(context).pop();
          },
          buttonName: "Continue",
        ),

      ],
    );
  }
}

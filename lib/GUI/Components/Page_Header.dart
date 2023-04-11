import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:flutter/material.dart';


PreferredSizeWidget Page_Header({required BuildContext context, required String pageName, required List<Widget> buttons}){
  return AppBar(
    backgroundColor: Color_Manager.of(context).primary_color,
    title: Text(pageName,
      style: TextStyle(
        color: Color_Manager.of(context).text_color,
      ),
    ),
    actions: [Row(
      children: buttons,
    ),]

  );
}
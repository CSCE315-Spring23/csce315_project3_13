import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:flutter/material.dart';

Widget Login_TextField({required BuildContext context, Function? onSubmitted, required TextEditingController textController, bool obscureText = false, String labelText = ""}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      cursorColor: Color_Manager.of(context).text_color,
      style: TextStyle(
        decorationColor: Color_Manager.of(context).active_color,
        color: Color_Manager.of(context).text_color,
      ),
      controller: textController,
      onSubmitted: (String pass_string){
        if(onSubmitted != null){
          onSubmitted();
        }
      },
      obscureText: obscureText,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Color_Manager.of(context).text_color,
        ),
        focusColor: Color_Manager.of(context).text_color,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color_Manager.of(context).text_color),
          borderRadius: BorderRadius.circular(4),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color_Manager.of(context).text_color),
          borderRadius: BorderRadius.circular(4),
        ),
        labelText: labelText,
      ),),
  );
}
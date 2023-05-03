/// A widget that displays a text input field for login purposes.
/// The Login_TextField widget is used to display a text input field for login purposes. It is designed to inherit the
/// theme and color scheme of its parent context. It supports customizable text input and password hiding.
/// Required parameters:
/// context: the build context of the parent widget.
/// textController: the text editing controller that manages the state of the input field.
/// Optional parameters:
/// obscureText: a boolean that determines whether the input text should be obscured (useful for passwords).
/// labelText: the text that appears above the input field.
/// onSubmitted: a function that will be called when the user submits the text via the keyboard.

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
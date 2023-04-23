import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:flutter/material.dart';


class Contrast_Button extends StatefulWidget {
  const Contrast_Button({Key? key}) : super(key: key);

  @override
  State<Contrast_Button> createState() => _Contrast_ButtonState();
}

class _Contrast_ButtonState extends State<Contrast_Button> {

  bool is_standard = true;

  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);

    return Login_Button(
      onTap: (){
          _color_manager.option_deuteranopia();

      },
      buttonName: "High Contrast",
      fontSize: 15,
    );
  }
}

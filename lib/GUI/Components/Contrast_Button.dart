import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:flutter/material.dart';


class Contrast_Button extends StatefulWidget {
  const Contrast_Button({Key? key}) : super(key: key);

  @override
  State<Contrast_Button> createState() => _Contrast_ButtonState();
}

class _Contrast_ButtonState extends State<Contrast_Button> {


  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);

    return Login_Button(
      onTap: (){
        if(_color_manager.is_high_contrast){
          _color_manager.reset_colors();
        }else{
          _color_manager.color_blind_option_1();
        }
      },
      buttonName: "High Contrast",
      fontSize: 15,
    );
  }
}

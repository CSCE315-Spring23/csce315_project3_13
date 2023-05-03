import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:flutter/material.dart';

/// A button widget that toggles the color contrast of the app.
/// This widget uses the Color_Manager inherited widget to manage the color contrast
/// of the app. When the user taps the button, the option_deuteranopia() method of
/// the Color_Manager is called to toggle the color contrast between standard and high contrast.
/// The Contrast_Button is a stateful widget because it needs to maintain the current color contrast state
/// in its _Contrast_ButtonState state.

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

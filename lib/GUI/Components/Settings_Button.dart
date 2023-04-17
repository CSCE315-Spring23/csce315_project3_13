import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Settings_Dialog.dart';
import 'package:flutter/material.dart';


class Settings_Button extends StatefulWidget {
  const Settings_Button({Key? key}) : super(key: key);

  @override
  State<Settings_Button> createState() => _Settings_ButtonState();
}

class _Settings_ButtonState extends State<Settings_Button> {


  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Settings_Dialog();
            },
          );
        },
        icon: const Icon(Icons.settings,
        size: 15,
          color: Colors.white,
        ),


    );
  }
}

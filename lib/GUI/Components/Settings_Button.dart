import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Settings_Dialog.dart';
import 'package:flutter/material.dart';


class Settings_Buttons extends StatefulWidget {
  const Settings_Buttons({Key? key}) : super(key: key);

  @override
  State<Settings_Buttons> createState() => _Settings_ButtonsState();
}

class _Settings_ButtonsState extends State<Settings_Buttons> {


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

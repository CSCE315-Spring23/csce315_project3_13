import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:flutter/material.dart';


class Settings_Dialog extends StatefulWidget {
  const Settings_Dialog({Key? key}) : super(key: key);

  @override
  State<Settings_Dialog> createState() => _Settings_DialogState();
}

class _Settings_DialogState extends State<Settings_Dialog> {

  String dropdownValue = 'English';

  List<bool> _isSelected = [true, false, false, false];



  @override
  Widget build(BuildContext context) {


    final _color_manager = Color_Manager.of(context);

    void change_color({required int color_choice_index}){
      setState(() {
        if(color_choice_index == 0){
          _color_manager.reset_colors();
        }else if(color_choice_index == 1){
          _color_manager.option_protanopia();
        }else if(color_choice_index == 2){
          _color_manager.option_deuteranopia();
        }else if(color_choice_index == 3){
          _color_manager.option_tritanopia();
        }
      });

      }




    return AlertDialog(
      title: Text('Settings'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Select Color option"),
                ToggleButtons(
                  direction: Axis.vertical,
                  isSelected: _isSelected,
                  onPressed: (int index) {
                    setState(() {
                      for(int i =0; i < _isSelected.length; i++){
                        _isSelected[i] = false;
                      }

                      _isSelected[index] = true;
                      change_color(
                        color_choice_index: index,
                      );
                    });
                  },
                  children: [
                    Text("Standard"),
                    Text("Protanopia"),
                    Text("Deuteranopia"),
                    Text("Tritanopia"),
                  ],
                )
              ],

            ),
          ),

          Column(
            children: [
              Text("Select language"),

              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue = newValue as String;
                  });
                },
                items: <String>['English', 'Spanish']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )


            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            // Perform some action here
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

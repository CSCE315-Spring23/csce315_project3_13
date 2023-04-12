import 'package:flutter/material.dart';


class Settings_Dialog extends StatefulWidget {
  const Settings_Dialog({Key? key}) : super(key: key);

  @override
  State<Settings_Dialog> createState() => _Settings_DialogState();
}

class _Settings_DialogState extends State<Settings_Dialog> {

  String dropdownValue = 'English';

  List<bool> _isSelected = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings'),
      content: ListView(
        children: [
          Column(

            children: [
              Text("Select Color option"),


              // ToggleButtons(
              //   isSelected: _isSelected,
              //   onPressed: (int index) {
              //     setState(() {
              //       _isSelected[index] = !_isSelected[index];
              //     });
              //   },
              //   children: [
              //     Icon(Icons.ac_unit),
              //     Icon(Icons.call),
              //     Icon(Icons.cake),
              //   ],
              // )
            ],

          ),

          Column(
            children: [
              Text("Select language"),

              // DropdownButton<String>(
              //   value: dropdownValue,
              //   onChanged: (newValue) {
              //     setState(() {
              //       dropdownValue = newValue as String;
              //     });
              //   },
              //   items: <String>['English', 'Spanish']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // )


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

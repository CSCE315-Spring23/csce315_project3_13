import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:flutter/material.dart';


class Settings_Dialog extends StatefulWidget {
  const Settings_Dialog({Key? key}) : super(key: key);

  @override
  State<Settings_Dialog> createState() => _Settings_DialogState();
}

class _Settings_DialogState extends State<Settings_Dialog> {

  String dropdownValue = "English";

  int dropdown_value_index = 0;


  List<bool> _isSelected = [true, false, false, false];

  google_translate_API _google_translate_api = google_translate_API();

  //Keeps track of whether to update name or not
  bool call_set_translation = true;

  //Strings for display
  String text_page_header = "Settings";
  String text_select_color_option = "Select Color option";
  String text_select_language = "Select language";
  String text_save = "Ok";
  List<String> language_choices = ["English", "Spanish"];
  List<String> color_choices = ["Standard", "Protanopia", "Deuteranopia","Tritanopia"];




  @override
  Widget build(BuildContext context) {


    // ToDo Implement the below translation functionality
    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {
      call_set_translation = false;

      //set the new Strings here
      text_page_header = (await _google_translate_api.translate_string("Settings",_translate_manager.chosen_language) as String);
      text_select_color_option = (await _google_translate_api.translate_string("Select Color option",_translate_manager.chosen_language) as String );
      text_select_language =(await _google_translate_api.translate_string( "Select language",_translate_manager.chosen_language) as String);
      text_save = (await _google_translate_api.translate_string("Ok",_translate_manager.chosen_language) as String);
      language_choices = (await _google_translate_api.translate_batch(<String>["English", "Spanish"],_translate_manager.chosen_language) as List<String>);
      dropdownValue = language_choices[dropdown_value_index];
      color_choices = (await _google_translate_api.translate_batch(<String>["Standard", "Protanopia", "Deuteranopia","Tritanopia"],_translate_manager.chosen_language) as List<String>);

      setState(() {
      });
    }

    if(call_set_translation){
      set_translation();
    }else{
      call_set_translation = true;
    }

    //Translation functionality end

    void set_language_dropdown(){
      if(_translate_manager.chosen_language == "en"){
        dropdown_value_index = 0;
        dropdownValue = language_choices[dropdown_value_index];
      }else if(_translate_manager.chosen_language == "es"){
        dropdown_value_index = 1;
        dropdownValue = language_choices[dropdown_value_index];
      }
    }

    void set_language(String newLanguageChoice){
      if(newLanguageChoice == language_choices[0]){
        _translate_manager.change_language("en");
      }else if(newLanguageChoice == language_choices[1]){
        _translate_manager.change_language("es");
      }
    }

    set_language_dropdown();


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
      title: Text(text_page_header),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(text_select_color_option),
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
                    Text(color_choices[0]),
                    Text(color_choices[1]),
                    Text(color_choices[2]),
                    Text(color_choices[3]),
                  ],
                ),
              ],

            ),
          ),

          Column(
            children: [
              Text(text_select_language),

              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue = newValue as String;
                    set_language(dropdownValue);
                  });
                },
                items: language_choices
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),


            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(text_save),
          onPressed: () {
            // Perform some action here
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

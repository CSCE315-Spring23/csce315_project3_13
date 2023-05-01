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

  List<bool> _isSelected = [false, false, false];

  google_translate_API _google_translate_api = google_translate_API();

  //Keeps track of whether to update name or not
  bool call_set_translation = true;

  //Strings for display
  List<String> list_page_texts_originals = ["Settings", "Select Color", "Select language", "Accept"];
  List<String> list_page_texts = ["Settings", "Select Color option", "Select language", "Accept"];

  String text_page_header = "Settings";
  String text_select_color_option = "Select Color";
  String text_select_language = "Select language";
  String text_save = "Accept";
  List<String> language_choices_originals = ["English", "Spanish", "French", "Russian", "Korean"];
  List<String> language_choices = ["English", "Spanish", "French", "Russian", "Korean"];
  List<String> color_choices_originals = ["Standard", "Protanopia/Deuteranopia","Tritanopia"];
  List<String> color_choices = ["Standard", "Protanopia/Deuteranopia","Tritanopia"];




  @override
  Widget build(BuildContext context) {


    // ToDo Implement the below translation functionality
    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {
      call_set_translation = false;

      //set the new Strings here
      list_page_texts = (await _google_translate_api.translate_batch(list_page_texts_originals,_translate_manager.chosen_language));

      text_page_header = list_page_texts[0];
      text_select_color_option = list_page_texts[1];
      text_select_language = list_page_texts[2];
      text_save = list_page_texts[3];
      language_choices = (await _google_translate_api.translate_batch(language_choices_originals,_translate_manager.chosen_language));
      dropdownValue = language_choices[dropdown_value_index];
      color_choices = (await _google_translate_api.translate_batch(color_choices_originals,_translate_manager.chosen_language));

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
      else if(_translate_manager.chosen_language == "fr"){
        dropdown_value_index = 2;
        dropdownValue = language_choices[dropdown_value_index];
      }
      else if(_translate_manager.chosen_language == "ru"){
        dropdown_value_index = 3;
        dropdownValue = language_choices[dropdown_value_index];
      }
      else if(_translate_manager.chosen_language == "ko"){
        dropdown_value_index = 4;
        dropdownValue = language_choices[dropdown_value_index];
      }
    }

    void set_language(String newLanguageChoice){
      if(newLanguageChoice == language_choices[0]){
        _translate_manager.change_language("en");
      }else if(newLanguageChoice == language_choices[1]){
        _translate_manager.change_language("es");
      }else if(newLanguageChoice == language_choices[2]){
        _translate_manager.change_language("fr");
      }else if(newLanguageChoice == language_choices[3]){
        _translate_manager.change_language("ru");
      }else if(newLanguageChoice == language_choices[4]){
        _translate_manager.change_language("ko");
      }
    }

    set_language_dropdown();


    final _color_manager = Color_Manager.of(context);

    _isSelected[_color_manager.selected_option_index] = true;

    void change_color({required int color_choice_index}){
      setState(() {
        if(color_choice_index == 0){
          _color_manager.reset_colors();
        }else if(color_choice_index == 1){
          _color_manager.option_protanopia();
        }else if(color_choice_index == 2){
          _color_manager.option_tritanopia();
        }
        // else if(color_choice_index == 3){
        //
        // }
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
                    // Text(color_choices[3]),
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

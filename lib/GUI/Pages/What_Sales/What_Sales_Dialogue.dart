import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Translate_Manager.dart';
import 'package:csce315_project3_13/Inherited_Widgets/What_Sales_Manager.dart';
import 'package:csce315_project3_13/Services/google_translate_API.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class WhatSalesDialogue extends StatefulWidget {
  const WhatSalesDialogue({Key? key}) : super(key: key);

  @override
  State<WhatSalesDialogue> createState() => _WhatSalesDialogueState();
}

class _WhatSalesDialogueState extends State<WhatSalesDialogue> {

  //Keeps track of whether to update name or not
  bool call_set_translation = true;

  late TextEditingController _date1Controller;
  late TextEditingController _date2Controller;
  DateTime? pickedDate1;
  DateTime? pickedDate2;

  List<String> list_page_texts_originals = ["Choose dates", "Enter First Date", "Enter Second Date", "Continue", "Cancel", "Error choosing dates", "Please re-enter dates", "Ok"];
  List<String> list_page_texts = ["Choose dates", "Enter First Date", "Enter Second Date", "Continue", "Cancel", "Error choosing dates", "Please re-enter dates", "Ok"];
  String text_page_title = "Choose dates";
  String text_first_date = "Enter First Date";
  String text_second_date = "Enter Second Date";
  String text_continue_button = "Continue";
  String text_cancel_button = "Cancel";
  String text_err_choose = "Error choosing dates";
  String text_reenter = "Please re-enter dates";
  String text_ok = "Ok";


  google_translate_API _google_translate_api = google_translate_API();




  @override
  void initState() {
    _date1Controller = TextEditingController();
    _date2Controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _date1Controller.dispose();
    _date2Controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    What_Sales_Manager _what_sales_man =  What_Sales_Manager.of(context);

    final _color_manager = Color_Manager.of(context);

    // ToDo Implement the below translation functionality
    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {
      call_set_translation = false;

      //set the new Strings here
      list_page_texts = (await _google_translate_api.translate_batch(list_page_texts_originals,_translate_manager.chosen_language));
      text_page_title =  list_page_texts[0];
      text_first_date = list_page_texts[1];
      text_second_date = list_page_texts[2];
      text_continue_button = list_page_texts[3];
      text_cancel_button = list_page_texts[4];
      text_err_choose = list_page_texts[5];
      text_reenter = list_page_texts[6];
      text_ok = list_page_texts[7];

      setState(() {
      });
    }

    if(call_set_translation){
      set_translation();
    }else{
      call_set_translation = true;
    }

    //Translation functionality end

    return AlertDialog(
      title: Text(text_page_title + ":",
      style: TextStyle(
        color: _color_manager.text_color,
      ),
      ),
      backgroundColor: _color_manager.background_color,
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
                cursorColor: _color_manager.text_color,
                controller: _date1Controller, //editing controller of this TextField
                style: TextStyle(
                  decorationColor: Color_Manager.of(context).active_color,
                  color: Color_Manager.of(context).text_color,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Color_Manager.of(context).text_color,
                  ),
                    icon: Icon(Icons.calendar_today,
                    color: _color_manager.text_color,
                    ), //icon of text field
                    labelText: text_first_date, //label text of field

                  focusColor: Color_Manager.of(context).text_color,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color_Manager.of(context).text_color),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color_Manager.of(context).text_color),
                    borderRadius: BorderRadius.circular(4),
                  ),

                ),
                readOnly: false,  // when true user cannot edit text
                onTap: () async {
                  pickedDate1 = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate:DateTime(2020), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime.now()
                  );
                  if(pickedDate1 != null ){
                    String formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate1 as DateTime); // format date in required form here we use yyyy-MM-dd that means time is removed

                    setState(() {
                      _date1Controller.text = formattedDate1; //set foratted date to TextField value.
                    });
                  }else{
                    print("Date is not selected");
                  }

                  //when click we have to show the datepicker
                }
            ),

            TextField(
                controller: _date2Controller, //editing controller of this TextField
                cursorColor: _color_manager.text_color,
                style: TextStyle(
                  decorationColor: Color_Manager.of(context).active_color,
                  color: Color_Manager.of(context).text_color,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Color_Manager.of(context).text_color,
                  ),
                  icon: Icon(Icons.calendar_today,
                    color: _color_manager.text_color,
                  ), //icon of text field
                  labelText: text_second_date, //label text of field

                  focusColor: Color_Manager.of(context).text_color,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color_Manager.of(context).text_color),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color_Manager.of(context).text_color),
                    borderRadius: BorderRadius.circular(4),
                  ),

                ),
                readOnly: false,  // when true user cannot edit text
                onTap: () async {
                  pickedDate2 = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate:DateTime(2020), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime.now()
                  );
                  if((pickedDate2 != null)){

                      String formattedDate2 = DateFormat('yyyy-MM-dd').format(pickedDate2 as DateTime); // format date in required form here we use yyyy-MM-dd that means time is removed

                      setState(() {
                        _date2Controller.text = formattedDate2; //set foratted date to TextField value.
                      });

                  }else{
                    print("Date is not selected");
                  }

                  //when click we have to show the datepicker
                }
            ),



          ],
        ),
      ),
      actions: <Widget>[
        Login_Button(onTap: (){
          Navigator.pop(context);
        },
          buttonName: text_cancel_button,
        ),
        Login_Button(
          onTap: (){
            if(pickedDate1 != null){
              if(pickedDate2?.isAfter(pickedDate1 as DateTime)??false){
                _what_sales_man.change_dates(_date1Controller.text, _date2Controller.text);
              }else{
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: Text(text_err_choose),
                    content: Center(
                      child: Text(text_reenter),
                    ),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text(text_ok)),
                    ],
                  );
                });
              }
            }


            Navigator.of(context).pop();
          },
          buttonName: text_continue_button,
        ),

      ],
    );
  }
}

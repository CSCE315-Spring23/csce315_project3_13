import 'package:csce315_project3_13/GUI/Pages/Sales%20Reports/Win_Itemized_Reports.dart';
import 'package:csce315_project3_13/GUI/Pages/Sales%20Reports/Win_What_Sales.dart';
import 'package:csce315_project3_13/GUI/Pages/Sales%20Reports/Win_Z_Reports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Inherited_Widgets/Translate_Manager.dart';
import '../../../Services/general_helper.dart';
import '../../../Services/google_translate_API.dart';
import '../../../Services/reports_helper.dart';
import '../../Components/Login_Button.dart';
import '../../Components/Page_Header.dart';
import '../Manager_View/Win_Manager_View.dart';
import 'Win_Excess_Reports.dart';

class Win_Reports_Hub extends StatefulWidget {
  static const String route = '/reports-hub';
  const Win_Reports_Hub({super.key});

  @override
  State<Win_Reports_Hub> createState() => _Win_Reports_HubState();
}

class _Win_Reports_HubState extends State<Win_Reports_Hub> {

  //Keeps track of whether to update name or not
  bool call_set_translation = true;
  google_translate_API _google_translate_api = google_translate_API();

  //Strings for display
  List<String> list_page_texts_originals = ["Reports Hub", "Return to Manager View", "Today's X Report:", "X Reports", "Z Reports", "Itemized Reports", "What Sales Together", "Excess Reports"];
  List<String> list_page_texts = ["Reports Hub", "Return to Manager View", "Today's X Report:", "X Reports", "Z Reports", "Itemized Reports", "What Sales Together", "Excess Reports"];
  String text_page_header = "Reports Hub";
  String text_back_button = "Return to Manager View";
  String text_x_report = "Today's X Report:";
  String text_x = "X Reports";
  String text_z = "Z Reports";
  String text_itemized = "Itemized Reports";
  String text_what_sales = "What Sales Together";
  String text_excess = "Excess Reports";

  general_helper gen_helper = general_helper();
  reports_helper rep_helper = reports_helper();

  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);

    final _translate_manager = Translate_Manager.of(context);

    Future<void> set_translation() async {
      call_set_translation = false;

      //set the new Strings here
      list_page_texts = (await _google_translate_api.translate_batch(list_page_texts_originals,_translate_manager.chosen_language));
      text_page_header = list_page_texts[0];
      text_back_button = list_page_texts[1];
      text_x_report = list_page_texts[2];
      text_x = list_page_texts[3];
      text_z = list_page_texts[4];
      text_itemized = list_page_texts[5];
      text_what_sales = list_page_texts[6];
      text_excess = list_page_texts[7];

      setState(() {
      });
    }

    if(call_set_translation){
      set_translation();
    }else{
      call_set_translation = true;
    }

    return Scaffold(
      backgroundColor: _color_manager.background_color,
      appBar: Page_Header(
        context: context,
        pageName: text_page_header,
        buttons: [
          IconButton(
            tooltip: text_back_button,
            padding: const EdgeInsets.only(left: 25, right: 10),
            onPressed: ()
            {
              Navigator.pushReplacementNamed(context,Win_Manager_View.route);

            },
            icon: const Icon(Icons.close_rounded),
            iconSize: 40,
          ),],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Login_Button(onTap: () async {
                    String current_date = await gen_helper.get_current_date();
                    double x_rep = await rep_helper.get_z_report(current_date);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("$text_x_report $x_rep"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            )
                          ],
                        );
                      },
                    );
                  }, buttonName: text_x, fontSize: 18, buttonWidth: 180,),
                  Login_Button(onTap: (){
                    Navigator.pushReplacementNamed(context,Win_Z_Reports.route);
                  }, buttonName: text_z, fontSize: 18, buttonWidth: 180,),
                  Login_Button(onTap: (){
                    Navigator.pushReplacementNamed(context,Win_Itemized_Reports.route);
                  }, buttonName: text_itemized, fontSize: 18, buttonWidth: 180,),
                  Login_Button(onTap: (){
                    Navigator.pushReplacementNamed(context,Win_What_Sales.route);
                  }, buttonName: text_what_sales, fontSize: 18, buttonWidth: 180,),
                  Login_Button(onTap: (){
                    Navigator.pushReplacementNamed(context,Win_Excess_Reports.route);
                  }, buttonName: text_excess, fontSize: 18, buttonWidth: 180,),
                ],
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
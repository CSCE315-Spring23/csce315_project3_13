import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Inherited_Widgets/Translate_Manager.dart';
import '../../../Services/excess_helper.dart';
import '../../../Services/general_helper.dart';
import '../../../Services/google_translate_API.dart';
import '../../Components/Page_Header.dart';
import 'Win_Reports_Hub.dart';

class Win_Excess_Reports extends StatefulWidget {
  static const String route = '/excess-reports';
  const Win_Excess_Reports({super.key});

  @override
  State<Win_Excess_Reports> createState() => _Win_Excess_ReportsState();
}

class _Win_Excess_ReportsState extends State<Win_Excess_Reports> {
  general_helper gen_help = general_helper();
  excess_helper exc_help = excess_helper();
  DateTime date = DateTime.now();
  List<String> rows = [];
  bool dataLoaded = true;

  bool call_set_translation = true;
  google_translate_API _google_translate_api = google_translate_API();

  //Strings for display
  List<String> list_page_texts_originals = ["Excess Reports", "Return to Reports Hub", "Get Excess Report", "No data."];
  List<String> list_page_texts = ["Excess Reports", "Return to Reports Hub", "Get Excess Report", "No data."];
  String text_page_header = "Excess Reports";
  String text_back_button = "Return to Reports Hub";
  String text_get_button = "Get Excess Report";
  String text_no_data = "No data.";

  void getData(String date) async
  {
    print("Getting data... with $date");

    rows = await exc_help.excess_report(date);

    for(int i = 0; i < rows.length; i++) {
      String name = rows[i];
      print("Made row for $name.");
    }
    setState(()
    {
      dataLoaded = true;
    });
  }

  Widget salesList(List<String> rows, Color _text_color, Color _box_color)
  {
    print("Constructing sales list...");
    if (rows.isEmpty) {
      return Text(text_no_data,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _text_color,
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: rows.length,
        itemBuilder: (BuildContext context, int index) =>
            Card(
                color: _box_color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('${rows[index]}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _text_color,
                    ),
                  ),
                )
            ),
      );
    }
  }

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
      text_get_button = list_page_texts[2];
      text_no_data = list_page_texts[3];

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
              Navigator.pushReplacementNamed(context,Win_Reports_Hub.route);

            },
            icon: const Icon(Icons.close_rounded),
            iconSize: 40,
          ),],
      ),
      body: !dataLoaded ?  Center(
        child: SpinKitRing(color: _color_manager.primary_color) ,
      ) : Center(
        child: SizedBox(
          child: salesList(rows, _color_manager.text_color, _color_manager.active_color),
        ),
      ),
      bottomSheet: Container
        (
        height: 75,
        color: _color_manager.primary_color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Login_Button(
              onTap: () async {
                DateTime ? newDate = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );

                if (newDate == null) return;

                setState(() => date = newDate);

                var formatter = DateFormat('MM/dd/yyyy');
                String formattedDate = formatter.format(date);

                dataLoaded = false;

                getData(formattedDate);
              },
              buttonName: text_get_button, fontSize: 18, buttonWidth: 180,),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
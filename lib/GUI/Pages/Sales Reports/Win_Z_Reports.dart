import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Inherited_Widgets/Translate_Manager.dart';
import '../../../Services/general_helper.dart';
import '../../../Services/google_translate_API.dart';
import '../../../Services/reports_helper.dart';
import '../../Components/Page_Header.dart';
import 'Win_Reports_Hub.dart';

class Win_Z_Reports extends StatefulWidget {
  static const String route = '/z-reports';
  const Win_Z_Reports({super.key});

  @override
  State<Win_Z_Reports> createState() => _Win_Z_ReportsState();
}

class _Win_Z_ReportsState extends State<Win_Z_Reports> {
  general_helper gen_help = general_helper();
  reports_helper rep_help = reports_helper();
  DateTime date = DateTime.now();
  List<String> dates = [];
  List<double> sales = [];
  bool dataLoaded = false;

  bool call_set_translation = true;
  google_translate_API _google_translate_api = google_translate_API();

  //Strings for display
  List<String> list_page_texts_originals = ["Z Reports", "Return to Reports Hub", "Get Z Report", "Z report for the chosen date"];
  List<String> list_page_texts = ["Z Reports", "Return to Reports Hub", "Get Z Report", "Z report for the chosen date"];
  String text_page_header = "Z Reports";
  String text_back_button = "Return to Reports Hub";
  String text_get_button = "Get Z Report";
  String text_z_report = "Z report for the chosen date";

  void getData() async
  {
    print("Getting data...");
    Map<String, double> all_reports = await rep_help.get_all_z_reports();
    for (MapEntry<String, double> e in all_reports.entries) {
      dates.add(e.key);
      sales.add(e.value);
    }

    for (int i = 0; i < dates.length; i++) {
      print('Date ${dates[i]} Sales ${sales[i]}');
    }

    setState(()
    {
      dataLoaded = true;
    });
  }

  Widget salesList(List<String> dates, List<double> sales, Color _text_color, Color _box_color)
  {
    print("Constructing sales list...");
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: dates.length,
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
                child: Text('${dates[index]}: \$${sales[index]}',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: _text_color,
                  ),
                ),
            )
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
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
      text_z_report = list_page_texts[3];

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
          child: salesList(dates, sales, _color_manager.text_color, _color_manager.active_color),
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

                double z_rep = await rep_help.get_z_report(formattedDate);

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("$text_z_report: $z_rep"),
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
              },
              buttonName: text_get_button, fontSize: 18, buttonWidth: 180,),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Inherited_Widgets/Translate_Manager.dart';
import '../../../Models/models_library.dart';
import '../../../Services/general_helper.dart';
import '../../../Services/google_translate_API.dart';
import '../../../Services/reports_helper.dart';
import '../../Components/Page_Header.dart';
import 'Win_Reports_Hub.dart';

class Win_Itemized_Reports extends StatefulWidget {
  static const String route = '/itemized-reports';
  const Win_Itemized_Reports({super.key});

  @override
  State<Win_Itemized_Reports> createState() => _Win_Itemized_ReportsState();
}

class _Win_Itemized_ReportsState extends State<Win_Itemized_Reports> {
  general_helper gen_help = general_helper();
  reports_helper rep_help = reports_helper();
  DateTime date_1 = DateTime.now();
  DateTime date_2 = DateTime.now();
  List<sales_report_row> rows = [];
  bool dataLoaded = true;

  bool call_set_translation = true;
  google_translate_API _google_translate_api = google_translate_API();

  //Strings for display
  List<String> list_page_texts_originals = ["Itemized Sales Reports", "Return to Reports Hub", "Get Itemized Sales Report", "No data.", "sold", "units and made", "in revenue"];
  List<String> list_page_texts = ["Itemized Sales Reports", "Return to Reports Hub", "Get Itemized Sales Report", "No data.", "sold", "units and made", "in revenue"];
  String text_page_header = "Itemized Sales Reports";
  String text_back_button = "Return to Reports Hub";
  String text_get_button = "Get Itemized Sales Report";
  String text_no_data = "No data.";
  String sold = "sold";
  String units_and_made = "units and made";
  String in_revenue = "in revenue";

  void getData(String date1, String date2) async
  {
    print("Getting data... with $date1 and $date2");

    rows = await rep_help.generate_sales_report(date1, date2);

    for(int i = 0; i < rows.length; i++) {
      String name = rows[i].item_name;
      print("Made row for $name.");
    }
    setState(()
    {
      dataLoaded = true;
    });
  }

  Widget salesList(List<sales_report_row> rows, Color _text_color, Color _box_color)
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
              child: Text('${rows[index].item_name} $sold ${rows[index].amount_sold} $units_and_made \$${rows[index].total_revenue} $in_revenue.',
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
      sold = list_page_texts[4];
      units_and_made = list_page_texts[5];
      in_revenue = list_page_texts[6];

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
                DateTime ? newDate_1 = await showDatePicker(
                  context: context,
                  initialDate: date_1,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );

                if (newDate_1 == null) return;

                DateTime ? newDate_2 = await showDatePicker(
                  context: context,
                  initialDate: date_2,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );

                if (newDate_2 == null) return;

                setState(() => date_1 = newDate_1);
                setState(() => date_2 = newDate_2);

                var formatter = DateFormat('MM/dd/yyyy');
                String formattedDate_1 = formatter.format(date_1);
                String formattedDate_2 = formatter.format(date_2);

                dataLoaded = false;

                getData(formattedDate_1, formattedDate_2);
              },
              buttonName: text_get_button, fontSize: 18, buttonWidth: 180,),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
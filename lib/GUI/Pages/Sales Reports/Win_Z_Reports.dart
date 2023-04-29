import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Services/general_helper.dart';
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
    return Scaffold(
      backgroundColor: _color_manager.background_color,
      appBar: Page_Header(
        context: context,
        pageName: "Z Reports",
        buttons: [
          IconButton(
            tooltip: "Return to Reports Hub",
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
                      content: Text("Z report for the chosen date: $z_rep"),
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
              buttonName: "Get Z Report", fontSize: 18, buttonWidth: 180,),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
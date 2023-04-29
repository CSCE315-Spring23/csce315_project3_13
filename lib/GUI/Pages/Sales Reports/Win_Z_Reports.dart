import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  void getData() async
  {
    Map<String, double> all_reports = await rep_help.get_all_z_reports();
    for(MapEntry<String, double> e in all_reports.entries) {
      dates.add(e.key);
      sales.add(e.value);
    }
  }

  Widget salesList(List<String> dates, List<double> sales)
  {
    print("Constructing sales list...");
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: dates.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: Center(child: Text('Date ${dates[index]} Sales ${sales[index]}')),
          );
        }
    );
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
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
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
                    buttonName: "Get Z Report", fontSize: 18, buttonWidth: 180,)
                  // Calendar picker and z_reports database table
                ],
              ),
              salesList(dates, sales),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
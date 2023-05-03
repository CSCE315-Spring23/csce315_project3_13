import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Services/excess_helper.dart';
import '../../../Services/general_helper.dart';
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
      return Text('No data.',
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
    return Scaffold(
      backgroundColor: _color_manager.background_color,
      appBar: Page_Header(
        context: context,
        pageName: "Excess Reports",
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
              buttonName: "Get Excess Report", fontSize: 18, buttonWidth: 180,),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
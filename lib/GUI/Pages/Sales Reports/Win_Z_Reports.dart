import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../Components/Page_Header.dart';
import 'Win_Reports_Hub.dart';

class Win_Z_Reports extends StatefulWidget {
  static const String route = '/z-reports';
  const Win_Z_Reports({super.key});

  @override
  State<Win_Z_Reports> createState() => _Win_Z_ReportsState();
}

class _Win_Z_ReportsState extends State<Win_Z_Reports> {
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
                  // Calendar picker and z_reports database table
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
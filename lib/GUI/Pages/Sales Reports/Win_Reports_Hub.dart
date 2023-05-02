import 'package:csce315_project3_13/GUI/Pages/Sales%20Reports/Win_Itemized_Reports.dart';
import 'package:csce315_project3_13/GUI/Pages/Sales%20Reports/Win_Z_Reports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Inherited_Widgets/Color_Manager.dart';
import '../../../Services/general_helper.dart';
import '../../../Services/reports_helper.dart';
import '../../Components/Login_Button.dart';
import '../../Components/Page_Header.dart';
import '../Manager_View/Win_Manager_View.dart';

class Win_Reports_Hub extends StatefulWidget {
  static const String route = '/reports-hub';
  const Win_Reports_Hub({super.key});

  @override
  State<Win_Reports_Hub> createState() => _Win_Reports_HubState();
}

class _Win_Reports_HubState extends State<Win_Reports_Hub> {
  general_helper gen_helper = general_helper();
  reports_helper rep_helper = reports_helper();

  @override
  Widget build(BuildContext context) {
    final _color_manager = Color_Manager.of(context);
    return Scaffold(
      backgroundColor: _color_manager.background_color,
      appBar: Page_Header(
        context: context,
        pageName: "Reports Hub",
        buttons: [
          IconButton(
            tooltip: "Return to Manager View",
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
                          content: Text("Today's X Report: $x_rep"),
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
                  }, buttonName: "X Reports", fontSize: 18, buttonWidth: 180,),
                  Login_Button(onTap: (){
                    Navigator.pushReplacementNamed(context,Win_Z_Reports.route);
                  }, buttonName: "Z Reports", fontSize: 18, buttonWidth: 180,),
                  Login_Button(onTap: (){
                    Navigator.pushReplacementNamed(context,Win_Itemized_Reports.route);
                  }, buttonName: "Itemized Reports", fontSize: 18, buttonWidth: 180,),
                  Login_Button(onTap: (){
                    Navigator.pushReplacementNamed(context,Win_Manager_View.route);
                  }, buttonName: "What Sales Together", fontSize: 18, buttonWidth: 180,),
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
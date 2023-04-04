import 'package:csce315_project3_13/GUI/Components/ExampleButton.dart';
import 'package:csce315_project3_13/GUI/Pages/Login/Win_Login.dart';
import 'package:csce315_project3_13/GUI/Pages/Management/Win_View_Menu.dart';
import 'package:flutter/material.dart';

class Win_Manager_View extends StatefulWidget {
  static const String route = '/manager-view';
  const Win_Manager_View({Key? key}) : super(key: key);

  @override
  State<Win_Manager_View> createState() => _Win_Manager_ViewState();
}

class _Win_Manager_ViewState extends State<Win_Manager_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager View"),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, Win_View_Menu.route);
                },
                child: const Text('Menu Management')
            ),
            const Text(
              'Logged in',
            ),
            ExampleButton(
                onTap: (){
              print("Logging out");
              Navigator.pushReplacementNamed(context, Win_Login.route);
            },
            buttonName: "Log out"
            ),
          ],
        ),
      ),
      bottomSheet: Container(height: 100, color: Colors.red,),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

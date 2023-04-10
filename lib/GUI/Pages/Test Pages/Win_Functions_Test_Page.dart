import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Login_Button.dart';
import 'package:csce315_project3_13/Services/login_helper.dart';
import 'package:csce315_project3_13/Services/order_processing_helper.dart';
import 'package:csce315_project3_13/Services/weather_API.dart';
import 'package:flutter/material.dart';
import '../../../Services/testing_cloud_functions.dart';

class Win_Functions_Test_Page extends StatefulWidget {
  static const String route = '/functions-test-page';
  const Win_Functions_Test_Page({super.key});

  @override
  State<Win_Functions_Test_Page> createState() => _Win_Functions_Test_Page_StartState();
}

class _Win_Functions_Test_Page_StartState extends State<Win_Functions_Test_Page> {


  testing_cloud_functions cloud_functions_tester = testing_cloud_functions();
  order_processing_helper order_helper = order_processing_helper();
  login_helper login_helper_instance = login_helper();
  weather_API weather = weather_API();

  bool is_high_contrast = false;


  @override
  Widget build(BuildContext context) {
    final my_color_manager = Color_Manager.of(context);


    return Scaffold(
      appBar: AppBar(
        title: Text("Test functions page",
        style: TextStyle(
          color: my_color_manager.active_color,
        ),
        ),
      ),
      backgroundColor: my_color_manager.primary_color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ElevatedButton(
                onPressed: (){
              cloud_functions_tester.getEmployees();
            }, child: const Text("Test Firebase Function")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              cloud_functions_tester.getEmployeeByID(2);
            }, child: const Text("Test Firebase Function with parameter")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              login_helper_instance.is_signed_in();
            }, child: const Text("Get logged in user")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              // weather.get_user_city();
            }, child: const Text("Get UID")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              login_helper_instance.sign_out();
            }, child: const Text("Sign out")),
            const SizedBox(
              height: 20,
            ),
            Login_Button(onTap: (){
              if(is_high_contrast){
                my_color_manager.reset_colors();
                setState(() {
                  is_high_contrast = !is_high_contrast;
                });
              }else{
                my_color_manager.color_blind_option_1();
                setState(() {
                  is_high_contrast = !is_high_contrast;
                });
              }
            }, buttonName: "Change Color scheme",
              fontSize: 10,
              buttonColor: my_color_manager.active_color

            )





            // t
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
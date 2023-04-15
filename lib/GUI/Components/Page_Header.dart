import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/Services/Weather_Manager.dart';
import 'package:flutter/material.dart';


PreferredSizeWidget Page_Header({required BuildContext context, required String pageName, required List<Widget> buttons}){
  return AppBar(
    backgroundColor: Color_Manager.of(context).primary_color,
    title: Text(pageName,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    flexibleSpace: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Weather_Manager.of(context).current_condition == "Clear"? Icon(Icons.sunny, size: 15, color: Colors.white,) : SizedBox(),

          Weather_Manager.of(context).current_condition == "Drizzle"? Icon(Icons.water_drop_rounded, size: 15, color: Colors.white,) : SizedBox(),

          Weather_Manager.of(context).current_condition == "Rain"? Icon(Icons.water_drop_rounded, size: 15, color: Colors.white,) : SizedBox(),

          Weather_Manager.of(context).current_condition == "Clouds"? Icon(Icons.cloud, size: 15, color: Colors.white,) : SizedBox(),



          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Weather_Manager.of(context).current_condition,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Weather_Manager.of(context).current_tempurature,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),

            ),
          ),

        ],
      ),
    ),
    actions: [Row(
      children: buttons,
    ),]

  );
}
import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Settings_Button.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Weather_Manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


PreferredSizeWidget Page_Header({required BuildContext context, required String pageName, required List<Widget> buttons}){
  return AppBar(
    backgroundColor: Color_Manager.of(context).primary_color,
    centerTitle: false,
    title: Text(pageName,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    flexibleSpace: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Weather_Manager.of(context).current_condition == Weather_Manager.of(context).conditions_list[0]? const Icon(Icons.sunny, size: 15, color: Colors.white,) : SizedBox(),

          Weather_Manager.of(context).current_condition == Weather_Manager.of(context).conditions_list[1]? const Icon(Icons.water_drop_rounded, size: 15, color: Colors.white,) : SizedBox(),

          Weather_Manager.of(context).current_condition == Weather_Manager.of(context).conditions_list[2]? const Icon(Icons.water_drop_rounded, size: 15, color: Colors.white,) : SizedBox(),

          Weather_Manager.of(context).current_condition == Weather_Manager.of(context).conditions_list[3]? const Icon(Icons.cloud, size: 15, color: Colors.white,) : SizedBox(),

          Weather_Manager.of(context).current_condition == Weather_Manager.of(context).conditions_list[4]? const Icon(Icons.cloud_queue_sharp, size: 15, color: Colors.white,) : SizedBox(),

          Weather_Manager.of(context).current_condition == Weather_Manager.of(context).conditions_list[5]? const Icon(Icons.thunderstorm, size: 15, color: Colors.white,) : SizedBox(),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Weather_Manager.of(context).current_condition,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Weather_Manager.of(context).current_tempurature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),

            ),
          ),

        ],
      ),
    ),
    actions: [Row(
      children: <Widget>[const Settings_Button()] + buttons,
    ),]

  );
}
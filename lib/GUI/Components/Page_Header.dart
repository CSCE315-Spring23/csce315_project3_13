/// Builds a page header widget for the app bar.
/// The widget contains a logo, page name, weather condition and temperature (optional), and a list of buttons (optional).
/// If the weather condition is enabled, it will be displayed in an icon and text format, otherwise, it won't be displayed.
/// @param context The build context.
/// @param pageName The name of the page being displayed.
/// @param buttons A list of buttons to be displayed in the header.
/// @param showWeather A boolean that determines whether or not to display the current weather condition and temperature.
/// @return The page header widget.


import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Settings_Button.dart';
import 'package:csce315_project3_13/Inherited_Widgets/Weather_Manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:firebase_storage/firebase_storage.dart';


PreferredSizeWidget Page_Header({required BuildContext context, required String pageName, required List<Widget> buttons, bool showWeather = true}){
  return AppBar(
    backgroundColor: Color_Manager.of(context).primary_color,
    centerTitle: false,
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image(
        image: NetworkImage('https://raw.githubusercontent.com/CSCE315-Spring23/csce315_project3_13/main/assets/logo.png'),
        color: Color_Manager.of(context).text_color,

        // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        //   if (loadingProgress == null) {
        //     return child;
        //   }
        //   return Center(
        //     child: CircularProgressIndicator(
        //       value: loadingProgress.expectedTotalBytes != null
        //           ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes as double)
        //           : null,
        //     ),
        //   );
        // },
        // errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        //   return SizedBox();
        // },
      ),

    ),
    title: Text(
      pageName,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
    flexibleSpace: Center(
      child: showWeather? Row(
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
      ) : SizedBox(),
    ),
    actions: [Row(
      children: <Widget>[const Settings_Button()] + buttons,
    ),]

  );
}
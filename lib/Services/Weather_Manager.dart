import 'package:flutter/material.dart';

class Weather_Manager extends InheritedWidget {

  final String current_condition;
  final String current_tempurature;

  Weather_Manager({required this.current_condition, required this.current_tempurature, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(Weather_Manager old) {
    if((current_condition != old.current_condition) ||
        (current_tempurature != old.current_tempurature)
    ){
      return true;
    }else {
      return false;
    }
  }

  static Weather_Manager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Weather_Manager>() ?? Weather_Manager(child: const Text("Weather manager failed"), current_condition: "", current_tempurature: "", );
}
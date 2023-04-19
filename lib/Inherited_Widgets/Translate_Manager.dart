import 'package:flutter/material.dart';

class Color_Manager extends InheritedWidget {

  final String chosen_language;

  final Function change_language;



  Color_Manager({required this.chosen_language, required this.change_language, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(Color_Manager old) {
    if((chosen_language != old.change_language)
    ){
      return true;
    }else {
      return false;
    }
  }

  static Color_Manager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Color_Manager>() ?? Color_Manager(child: const Text("Color manager failed"), change_language: (){}, chosen_language: "",);
}
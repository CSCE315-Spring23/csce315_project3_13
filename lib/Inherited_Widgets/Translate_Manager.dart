import 'package:flutter/material.dart';

class Translate_Manager extends InheritedWidget {

  final String chosen_language;

  final Function change_language;



  Translate_Manager({required this.chosen_language, required this.change_language, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(Translate_Manager old) {
    if((chosen_language != old.change_language)
    ){
      return true;
    }else {
      return false;
    }
  }

  static Translate_Manager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Translate_Manager>() ?? Translate_Manager(child: const Text("Color manager failed"), change_language: (){}, chosen_language: "",);
}
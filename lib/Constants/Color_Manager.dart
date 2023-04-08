import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Color_Manager extends InheritedWidget {
  final Color primary_color;
  final Function update_color;

  Color_Manager({required this.primary_color ,required this.update_color, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(Color_Manager old) {
    return primary_color != old.primary_color;
  }

  static Color_Manager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Color_Manager>() ?? Color_Manager(child: Placeholder(), primary_color: Colors.blue, update_color: (){},);
}
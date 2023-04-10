import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Color_Manager extends InheritedWidget {
  final Color primary_color;
  final Color secondary_color;
  final Color background_color;
  final Color text_color;
  final Color active_color;
  final Color hover_color;
  final Color inactive_color;
  final Color active_size_color;
  final Color active_confirm_color;
  final Color active_deny_color;

  final Function reset_colors;
  final Function color_blind_option_1;

  Color_Manager({required this.primary_color, required this.secondary_color, required this.background_color, required this.text_color, required this.active_color, required this.inactive_color, required this.hover_color, required this.active_size_color, required this.active_confirm_color, required this.active_deny_color,required this.color_blind_option_1, required this.reset_colors, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(Color_Manager old) {
    if((primary_color != old.primary_color) ||
        (secondary_color != old.secondary_color) ||
        (background_color != old.background_color) ||
        (text_color != old.text_color) ||
        (active_color != old.active_color) ||
        (inactive_color != old.inactive_color) ||
        (active_size_color != old.active_size_color) ||
        (active_confirm_color != old.active_confirm_color) ||
        (active_deny_color != old.active_deny_color)||
        (hover_color != old.hover_color)
    ){
      return true;
    }else {
      return false;
    }
  }

  static Color_Manager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Color_Manager>() ?? Color_Manager(child: const Text("Color manager failed"), primary_color: Colors.blue, secondary_color: Colors.blue, background_color : Colors.blue, text_color : Colors.blue, active_color : Colors.blue, inactive_color : Colors.blue, active_size_color : Colors.blue, active_confirm_color : Colors.blue, active_deny_color : Colors.blue, hover_color: Colors.blue,  color_blind_option_1: (){}, reset_colors: (){},);
}
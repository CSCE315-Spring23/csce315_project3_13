import 'package:flutter/material.dart';

class What_Sales_Manager extends InheritedWidget {
  final String date1;
  final String date2;

  final Function change_dates;



  What_Sales_Manager({required this.date1, required this.date2, required this.change_dates, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(What_Sales_Manager old) {
    if((date1 != old.date1) ||
        (date2 != old.date2)
    ){
      return true;
    }else {
      return false;
    }
  }

  static What_Sales_Manager of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<What_Sales_Manager>() ?? What_Sales_Manager(child: SizedBox(), date1: "",date2: "", change_dates: (){},);
}